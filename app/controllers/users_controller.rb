class UsersController < ApplicationController
  skip_filter :require_login, :except => :show

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end


  # GET /users/new
  # GET /users/new.json
  def new
    if APP_CONFIG['registration_open']
      @user = User.new

      respond_to do |format|
        format.html # new.html.haml
        format.json { render json: @user }
      end
    else
      respond_to do |format|
        format.html {redirect_to root_url, :alert => "Registration is closed"}
        format.html {rener :json => "Registration is closed"}
      end
    end
  end

  # GET /users/1/edit
  def edit
    @user = current_user
  end

  # POST /users
  # POST /users.json
  def create
    if APP_CONFIG['registration_open']
      @user = User.new(params[:user])

      respond_to do |format|
        if @user.save
          format.html { redirect_to root_url, notice: 'User was successfully created.' }
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html {redirect_to root_url, :alert => "Registration is closed"}
        format.html {rener :json => "Registration is closed"}
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
