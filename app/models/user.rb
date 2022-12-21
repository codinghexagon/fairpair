class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :user_projects
  has_many :projects, through: :user_projects
  has_many :subordinates, class_name: "User", foreign_key: "lead_id"
  belongs_to :lead, class_name: "User", optional: true

  validates :email, uniqueness: true
  validates :user_name, presence: true

  enum role: {lead: 0, developer: 1}

  before_validation :nullify_password_for_developers


  attr_accessor :skip_password_validation  # virtual attribute to skip password validation while saving

  def nullify_password_for_developers 
    self.skip_password_validation = true if developer?
  end

  protected

  def password_required?
    return false if skip_password_validation
    super
  end
end
