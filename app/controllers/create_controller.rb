class CreateController < ApplicationController
    def index
      if session[:username]
        @user = User.find_by(username: session[:username])
      else
        redirect_to root_path
      end
    end

    def uploadBook
      respond_to do |format|
        format.js
      end
    end

    def convert
      dir = Rails.root.join('app','assets', 'images', 'anonymous', 'asd.pdf')
      done = Docsplit.extract_images(dir, output: Rails.root.join('app','assets', 'images', 'anonymous'), :format => [:jpg])
      puts done
    end

    def addBook
      @book = Book.new(book_params)
      @book.user_id = session[:user_id]
      if params[:path].present?
        file = params[:path]
        dir = Rails.root.join('app','assets', 'images', session[:username], @book.name) #GET DIRECTORY
        FileUtils.mkdir_p(dir) unless File.directory?(dir) #IF DIRECTORY EXISTS
        File.open(Rails.root.join(dir, "#{@book.name}.pdf"), 'wb') do |f|
          f.write(file.read)
        end
        @book.path = "#{session[:username]}/#{@book.name}"
        dir = Rails.root.join(dir, "#{@book.name}.pdf")
        Docsplit.extract_images(dir, output: Rails.root.join('app','assets', 'images', session[:username], @book.name), :format => [:jpg])
        File.delete(dir) if File.exist?(dir)
      end

      respond_to do |format|
        if @book.save
          format.html { redirect_to create_path, notice: 'Added new book.' }
        else
          format.html { render :index }
          format.json { render json: @book.errors, status: :unprocessable_entity }
        end
      end
      # dir = Rails.root.join('app','assets', 'images', 'anonymous', 'asd.pdf')
      # done = Docsplit.extract_images(dir, output: Rails.root.join('app','assets', 'images', 'anonymous'), :format => [:jpg])
      # puts done
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_book
        @book = Book.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def book_params
          params.permit(:name, :path, :id)
      end  
  end