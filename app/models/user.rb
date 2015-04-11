class User < ActiveRecord::Base
  validates_uniqueness_of :username
  acts_as_authentic do |config|
    config.require_password_confirmation = false
    config.ignore_blank_passwords = true
    config.validate_password_field = false
    config.logged_in_timeout = 4.hours
  end
  validates_presence_of :employee_number
  has_and_belongs_to_many :groups
  has_many :submissions
  has_many :taken_surveys, :source => :survey, :through => :submissions
  has_many :owned_surveys, :class_name => "Survey", :foreign_key => 'owner_id'
  has_and_belongs_to_many :editable_surveys, :class_name => "Survey", :join_table => 'editors_surveys'
  belongs_to :primary_affiliation, :class_name => 'Affiliation'
  has_and_belongs_to_many :affiliations

  def autoupdate
    self.ldap_update if self.ldap_updated_at < 10.minutes.ago
  end

  def admin?
    return self.groups.exists?(:name => 'Admin')
  end

  def creator?
    return self.groups.exists?(:name => 'Creator')
  end

  def faculty?
    return self.affiliations.exists?(:title => 'faculty')
  end

  def staff?
    return self.affiliations.exists?(:title => 'staff') || self.affiliations.exists?(:title => 'employee')
  end

  def ldap_update
    conn = LDAP::SSLConn.new('ldap.uma.edu', LDAP::LDAPS_PORT)
    conn.bind
    begin
      conn.search2('o=UMA', LDAP::LDAP_SCOPE_SUBTREE, '(&(objectClass=person)(employeeNumber=' + self.employee_number + '))', ['mail','sn','uid']) { |entry|
        #e = entry.to_hash
        self.email = entry["mail"][0] if entry.has_key?('mail') && (entry["mail"][0] != nil)
        self.username = entry["uid"][0] if entry.has_key?('uid') && (entry['uid'][0] != nil)
        #@e = entry
        #logger.debug { entry.inspect }
      }
    rescue LDAP::ResultError
      conn.perror("search")
    end
    conn.unbind

    #if self.email == nil
      umsconn = LDAP::SSLConn.new('namea.its.maine.edu', LDAP::LDAPS_PORT)
      umsconn.bind("cn=UMA Web Authentication,ou=Specials,dc=maine,dc=edu","ritic@pl",LDAP::LDAP_AUTH_SIMPLE)
      begin
        umsconn.search2('ou=People,dc=maine,dc=edu', LDAP::LDAP_SCOPE_SUBTREE, '(&(objectClass=person)(mainePersonType=primary)(employeeNumber=' + self.employee_number + '))', ['mail','sn','eduPersonPrimaryAffiliation','eduPersonAffiliation']) { |entry|
          #e = entry.to_hash
          self.email = entry["mail"][0] if self.email == nil
          self.primary_affiliation = Affiliation.find_or_create_by_title(entry['eduPersonPrimaryAffiliation'][0])
          self.affiliations.clear
          entry['eduPersonAffiliation'].each do |affiliation|
            self.affiliations << Affiliation.find_or_create_by_title(affiliation)
          end
        }
      rescue LDAP::ResultError
        umsconn.perror("search")
      end
      umsconn.unbind
    #end

    self.ldap_updated_at = Time.now
    self.save
    return self
  end
  
end
