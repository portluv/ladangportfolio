class CreateController < ApplicationController
  before_action :set_thing, only: [:showBook]

    def index
      if session[:username]
        @user = User.find_by(username: session[:username])
        index=0
        found=0
        found_idx=0
        @user.thing.each do |t|
          index+=1
          if t.thingtype_id == 1
            if found==0
              found_idx=index
            end
            found+=1
            if found > 1
              tempid=t.id
              tempthingtype_id=t.thingtype_id
              tempname=t.name
              temppath=t.path
              t.id = @user.thing[found_idx].id
              t.thingtype_id = @user.thing[found_idx].thingtype_id
              t.name = @user.thing[found_idx].name
              t.path = @user.thing[found_idx].path
              @user.thing[found_idx].id=tempid
              @user.thing[found_idx].thingtype_id=tempthingtype_id
              @user.thing[found_idx].name=tempname
              @user.thing[found_idx].path=temppath
              found_idx+=1
            end
            if found == 5
              found=0
            end
          end
        end
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
    
    def splitPDF
      @thing = Thing.new(thing_params)
      @status = Status.new
      @thing.user_id = session[:user_id]
      @status.user_id = session[:user_id]
      @status.status_type = 2
      if params[:path].present?
        file = params[:path]
        if @thing.thingtype_id == 1
          pathh = file.path
          Docsplit.extract_images(pathh, output: Rails.root.join('app','assets', 'images', 'user_assets', session[:username], @thing.name), :format => [:jpg])
          @thing.path = "user_assets/#{session[:username]}/#{@thing.name}/#{File.basename(file.path, '.pdf')}"
          @status.status = " just uploaded #{@thing.name}"
        end
      end
    end

    def addThing
      @thing = Thing.new(thing_params)
      @status = Status.new
      @thing.user_id = session[:user_id]
      @status.user_id = session[:user_id]
      @status.status_type = 2
      if params[:path].present?
        @thing.path = params[:thing_link]
        @status.status = " just uploaded #{@thing.name}"
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