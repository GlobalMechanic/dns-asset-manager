class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # Removed: :registerable, :recoverable,
  devise :database_authenticatable
        :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_accessible :role_ids, :as => :admin # <-- error is somewhere in here!!
  attr_accessible :login, :name, :email, :password, :password_confirmation, :remember_me, :current_reel_slug

  # Virtual attribute for authenticating by either name or email
	attr_accessor :login

  validates :name,  :presence => true, :uniqueness => true
  validates :email, :presence => true, :uniqueness => true

  has_many :reels

  #:before_logout delete_temp_reel

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.delete_temp_reel
    current_user.reels.delete_all(:title => nil)
  end
end
