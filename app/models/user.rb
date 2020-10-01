class User < ApplicationRecord
  # 生のパスワードと確認用パスワードを一時保存するための属性を生成
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :tasks
end
