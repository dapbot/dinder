# == Schema Information
#
# Table name: photos
#
#  id                    :integer          not null, primary key
#  photographable_id     :integer
#  low_resolution_url    :text
#  medium_resolution_url :text
#  high_resolution_url   :text
#  created_at            :datetime
#  updated_at            :datetime
#  source                :string(255)
#  photographable_type   :string(255)
#

class Photo < ActiveRecord::Base
  belongs_to :photographed, polymorphic: true

  def self.from_source(source)
    where("source = '#{source}'")
  end

  def self.not_hidden
    where(ignore: false)
  end

  default_scope {order("ignore ASC, source DESC")}

end
