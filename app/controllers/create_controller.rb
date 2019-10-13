class CreateController < ApplicationController
  before_action :set_thing, only: [:showBook]

    def index
      if session[:username]
        @user = User.find_by(username: session[:username])
        @thingtype = Thingtype.all
      else
        redirect_to root_path
      end
    end
    
    def showBook
      respond_to do |format|
        format.js
      end
    end

    def convert
      dir = Rails.root.join('app','assets', 'images', 'user_assets', 'anonymous', 'asd.pdf')
      done = Docsplit.extract_images(dir, :size => '100x', output: Rails.root.join('app','assets', 'images', 'user_assets', 'anonymous'), :format => [:jpg])
    end

    def addBook
      @thing = Thing.new(thing_params)
      @status = Status.new
      @thing.user_id = session[:user_id]
      @status.user_id = session[:user_id]
      @status.status_type = 2
      if params[:path].present?
        file = params[:path]
        if @thing.thingtype_id == 1
          pathh = file.path
          pathh.sub! 'AGUSTI~1.THE', 'agustinus.theodorus'
          Docsplit.extract_images(pathh, output: Rails.root.join('app','assets', 'images', 'user_assets', session[:username], @thing.name), :format => [:jpg])
          @thing.path = "user_assets/#{session[:username]}/#{@thing.name}/#{File.basename(file.path, '.pdf')}"
          @status.status = " just uploaded #{@thing.name}"
        elsif @thing.thingtype_id == 2
          dir = Rails.root.join('app','assets', 'images', 'user_assets', session[:username], @thing.name) #GET DIRECTORY
          FileUtils.mkdir_p(dir) unless File.directory?(dir) #IF DIRECTORY EXISTS
          random_id = (SecureRandom.random_number(9e5) + 1e5).to_i
          if File.exist?(Rails.root.join(dir, "#{@thing.name}-#{random_id}#{File.extname(file.path)}"))
            random_id = (SecureRandom.random_number(9e5) + 1e5).to_i
          end
          File.open(Rails.root.join(dir, "#{@thing.name}-#{random_id}#{File.extname(file.path)}"), 'wb') do |f|
            f.write(file.read)
          end
          @thing.path = "user_assets/#{session[:username]}/#{@thing.name}/#{@thing.name}-#{random_id}#{File.extname(file.path)}"
          @status.status = " just uploaded #{@thing.name}"
        end
      end

      respond_to do |format|
        if @thing.save 
          @status.save
          format.html { redirect_to create_path, notice: 'Added new Book.' }
        else
          format.html { redirect_to create_path, notice: 'Failed to add new Book.' }
          format.json { render json: @thing.errors, status: :unprocessable_entity }
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_thing
        @thing = Thing.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def thing_params
          params[:thingtype_id] = params[:thingtype_id].to_i
          params.permit(:name, :path, :thingtype_id, :id)
      end  
  end