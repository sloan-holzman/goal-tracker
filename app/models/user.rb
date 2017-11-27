class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :metrics, dependent: :destroy
  has_many :performances, through: :metrics
  has_many :memberships, dependent: :destroy
  has_many :groups, through: :memberships
  has_many :requests, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  before_save do |user|
    user.last_name = user.last_name.downcase.titleize
  end

  before_save do |user|
    user.first_name = user.first_name.downcase.titleize
  end

end
