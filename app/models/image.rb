class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true



  # Apply styling appropriate for this file
  has_attached_file :avatar, styles: lambda { |a| a.instance.check_file_type}, :default_url => "no_image.png"
  validates_attachment_content_type :avatar, :content_type => /.*/


  # The path of the image that will be shown while the file is loading
  def processing_image_path(image_name)
    "/assets/" + Rails.application.assets.find_asset(image_name).digest_path
  end  


  process_in_background :avatar, processing_image_url: lambda { |a| a.instance.processing_image_path("dad.jpg")}


  # IMPORTANT! The ffmpeg library has to added to the server machine. 
  # It can be uploaded from the official website https://www.ffmpeg.org/
  def check_file_type
    if is_image_type?
      {:large => "750x750>", :medium => "300x300#", :thumb => "100x100#" }
    elsif is_video_type?
      {
          :medium => { :geometry => "300x300#", :format => 'jpg'},
          :video => {:geometry => "640x360#", :format => 'mp4', :processors => [:transcoder]}
      }
    elsif is_audio_type?
      {
        :audio => {
          :format => "mp3", :processors => [:transcoder]
        }
      }
     # avatar_file_name = self.basename(:avatar_file_name, self.extname(:avatar_file_name))
    else
      {}
    end
  end



  # Method returns true if file's content type contains word 'image', overwise false
  def is_image_type?
    avatar_content_type =~ %r(image)
  end

  # Method returns true if file's content type contains word 'video', overwise false
  def is_video_type?
    avatar_content_type =~ %r(video)
  end

  # Method returns true if file's content type contains word 'audio', overwise false
  def is_audio_type?
    avatar_content_type =~ /\Aaudio\/.*\Z/
  end

end
