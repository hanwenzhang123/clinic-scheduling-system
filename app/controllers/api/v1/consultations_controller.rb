class Api::V1::ConsultationsController < ApplicationController
  def new
    @mconsultation = Consultation.new
  end

  def index
    @data = Consultation.all
    render json: @data
  end

  def show
    @data = Consultation.find(params[:id])
    render json: @data
  end

  def create
    @member = Member.find(consultation_params[:member_id])
    @provider = Provider.find(consultation_params[:provider_id])

    @consultation = Consultation.new(
      member: @member,
      provider: @provider,
      appointment_date: consultation_params[:appointment_date],
      start_time: consultation_params[:start_time]
    )
    
    if @consultation.save
      render json: { notice: 'Consultation was successfully created' }
    else
      render status: :unprocessable_entity do |format|
        format.html { render 'errors/422' }
        format.json { render json: { error: 'There was an error while creating the model.' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def consultation_params
    params.require(:consultation).permit(:member_id, :provider_id, :appointment_date, :start_time)
  end
end
