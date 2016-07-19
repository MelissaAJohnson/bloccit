class User < ActiveRecord::Base
  before_save { self.email = email.downcase if email.present? }
  before_save :capitalize_name

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true

  validates :password, presence: true, length: {minimum: 6}, unless: :password_digest
  validates :password, length: { minimum: 6 }, allow_blank: true

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  has_secure_password

  def capitalize_name
    if name
      name_array = []
      name.split.each do |n|
        name_array << n.capitalize
      end
      self.name = name_array.join(' ')
    end
  end

end
