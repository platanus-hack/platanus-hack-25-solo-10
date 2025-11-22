class VideoTranscription < ApplicationRecord
  has_one_attached :media
  has_many_attached :captures
end
