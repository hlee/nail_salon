class NailSalonsController < ApplicationController
  # GET /nail_salons
  # GET /nail_salons.json
  def index
    @nail_salons = NailSalon.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nail_salons }
    end
  end

  # GET /nail_salons/1
  # GET /nail_salons/1.json
  def show
    @nail_salon = NailSalon.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nail_salon }
    end
  end

  # GET /nail_salons/new
  # GET /nail_salons/new.json
  def new
    @nail_salon = NailSalon.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nail_salon }
    end
  end

  # GET /nail_salons/1/edit
  def edit
    @nail_salon = NailSalon.find(params[:id])
  end

  # POST /nail_salons
  # POST /nail_salons.json
  def create
    @nail_salon = NailSalon.new(params[:nail_salon])

    respond_to do |format|
      if @nail_salon.save
        format.html { redirect_to @nail_salon, notice: 'Nail salon was successfully created.' }
        format.json { render json: @nail_salon, status: :created, location: @nail_salon }
      else
        format.html { render action: "new" }
        format.json { render json: @nail_salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nail_salons/1
  # PUT /nail_salons/1.json
  def update
    @nail_salon = NailSalon.find(params[:id])

    respond_to do |format|
      if @nail_salon.update_attributes(params[:nail_salon])
        format.html { redirect_to @nail_salon, notice: 'Nail salon was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @nail_salon.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nail_salons/1
  # DELETE /nail_salons/1.json
  def destroy
    @nail_salon = NailSalon.find(params[:id])
    @nail_salon.destroy

    respond_to do |format|
      format.html { redirect_to nail_salons_url }
      format.json { head :no_content }
    end
  end
end
