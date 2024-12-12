require "cloudinary"
require "cloudinary/uploader"

class ArchivesController < ApplicationController
  before_action :set_archive, only: %i[ show edit update destroy ]
  before_action :validate_file_format, only: :create
  before_action :set_locale

  # GET /archives or /archives.json
  def index
    @archives = Archive.all
  end

  # GET /archives/1 or /archives/1.json
  def show
  end

  # GET /archives/new
  def new
    @archive = Archive.new
  end

  # GET /archives/1/edit
  def edit
  end

  # POST /archives or /archives.json
  def create
    uploaded_file = params[:archive][:file]

    result = Cloudinary::Uploader.upload(
      uploaded_file.path,
      resource_type: "image",
      transformation: [
        { width: 300, height: 300, crop: "fill" },
        { quality: "auto" },
        { fetch_format: "auto" }
      ],
      eager: [
        { width: 1024, height: 1024, crop: "limit" }
      ]
    )

    @archive = Archive.new(
      title: params[:archive][:title],
      description: params[:archive][:description],
      url: result["secure_url"],
      public_id: result["public_id"]
    )

    respond_to do |format|
      if @archive.save
        format.html { redirect_to @archive, notice: "Archive was successfully created." }
        format.json { render :show, status: :created, location: @archive }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /archives/1 or /archives/1.json
  def update
    respond_to do |format|
      if @archive.update(archive_params)
        format.html { redirect_to @archive, notice: "Archive was successfully updated." }
        format.json { render :show, status: :ok, location: @archive }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /archives/1 or /archives/1.json
  def destroy
    @archive.destroy!

    respond_to do |format|
      format.html { redirect_to archives_path, status: :see_other, notice: "Archive was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_archive
      @archive = Archive.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def archive_params
      params.require(:archive).permit(:title, :description, :file)
    end

    def validate_file_format
      uploaded_file = params[:archive][:file]
    valid_formats = %w[jpg jpeg png webp]
    file_format = File.extname(uploaded_file.original_filename).delete(".").downcase

    unless valid_formats.include?(file_format)
      render json: { error: "Invalid file format. Allowed formats are: #{valid_formats.join(', ')}" }, status: :unprocessable_entity
    end
    end
    def set_locale
      I18n.locale ||= I18n.default_locale
    end

    def default_url_options
      { locale: I18n.locale }
    end
end
