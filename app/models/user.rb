class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable

  has_many :dinder_searches

  def active_dinder_search
    self.dinder_searches.where("updated_at > ?", Time.zone.now - 1.hour).order("updated_at DESC").first
  end
end
