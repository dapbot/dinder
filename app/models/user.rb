# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0), not null
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :inet
#  last_sign_in_ip     :inet
#  created_at          :datetime
#  updated_at          :datetime
#  token               :string(255)
#  ever_swiped_yes     :boolean          default(FALSE)
#  ever_swiped_no      :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable

  has_many :dinder_searches
  has_many :clicks

  def active_dinder_search
    self.dinder_searches.where("updated_at > ?", Time.zone.now - 1.hour).order("updated_at DESC").first
  end
end
