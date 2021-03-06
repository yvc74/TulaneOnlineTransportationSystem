class Request < ActiveRecord::Base
    require 'csv'
    belongs_to :user
    has_many :locations
    
    validates :PULocation, :presence => true
    validates :DOLocation, :presence => true
    validates :PUDate, :presence => true
    validates :ArrivalTime, :presence => true
    validates :DepartureTime, :presence => true
    validate :not_past_date

    def not_past_date
        if self.PUDate.blank? == true
            errors.add(:date, 'date empty')
        elsif self.PUDate < Date.today.to_s && self.PUDate.blank? == false
            errors.add(:date, 'date past')
        end
    end
    
    def self.to_csv
        CSV.generate do |csv|
            csv << column_names
            all.each do |request|
                csv<< request.attributes.values_at(*column_names)
            end
        end
    end
end
