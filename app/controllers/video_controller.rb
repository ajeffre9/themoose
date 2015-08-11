class VideoController < ApplicationController
def create
  @video = Video.new(video_params)   

  if @video.save
    flash[:success] = :video_created
    redirect_to @video
  else
    flash.now[:error] = :video_not_created
    redirect_to @video
  end
end

end
