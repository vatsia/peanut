class ContactsController < ApplicationController
  include HTTParty

  before_action :set_contact, only: [:show, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    if not current_user.nil?
      @contacts = Contact.all
    else
      redirect_to create_contant
    end

  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    if not current_user.nil?
      @contacts = Contact.all
    else
      redirect_to contactp_path
    end
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end


  # POST /contacts
  # POST /contacts.json
  def create
    if verify_google_recaptsha(Rails.application.secrets.recaptsha_secret_key, params['g-recaptcha-response'])
      @contact = Contact.new(contact_params)

      respond_to do |format|
        if @contact.save
          format.html { redirect_to @contact, notice: 'Yhteydenotto lähetetty!.' }
          format.json { render :show, status: :created, location: @contact }
        else
          format.html { render :new }
          format.json { render json: @contact.errors, status: :unprocessable_entity }
        end
      end

    else
      redirect_to contactp_path, alert: 'Botti :('
    end

  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:content, 'g-recaptcha-response')
    end

    def verify_google_recaptsha(private_key, response)
      request = HTTParty.post('https://www.google.com/recaptcha/api/siteverify', :query => {
          "secret" => private_key,
          "response" => response
      }, :headers => {
          'Content-Type' => 'application/json'
      })

      parsed = request.parsed_response
      parsed['success'] == true ? true : false
    end
end
