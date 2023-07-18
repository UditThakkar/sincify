class ConverterController < ApplicationController

    def convert_playlist
        @url = params[:url]
    end

end
