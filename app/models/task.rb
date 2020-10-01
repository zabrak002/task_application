class Task < ApplicationRecord
  # 画像添付機能
  has_one_attached :image
  # Userと1対多
  belongs_to :user

  # ログイン機能
  def self.ransackable_attributes(auth_obuject = nil)
    %w[name created_at]
  end
  def self.ransackable_associations(auth_obuject = nil)
    []
  end

  # 存在チェック
  validates :name, presence: true
  
  # 文字列の長さが30文字以内
  validates :name, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  # ソート機能
  scope :recent, -> { order(created_at: :desc) }
  # Task.recent 全件新しい順
  # Task.recent.first 最も新しい

  # csv出力機能
  # export
  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{ |attr| task.send(attr) }
      end
    end
  end

  # import
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      task = new
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end


  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

end
