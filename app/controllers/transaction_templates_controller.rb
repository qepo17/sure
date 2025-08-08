class TransactionTemplatesController < ApplicationController
  before_action :set_template, only: %i[show edit update destroy]

  def index
    @transaction_templates = Current.family.transaction_templates.alphabetically
    render layout: "settings"
  end

  def show
    respond_to do |format|
      format.json { render json: template_json(@transaction_template) }
    end
  end

  def new
    @transaction_template = Current.family.transaction_templates.new
  end

  def edit; end

  def create
    if params[:transaction_id]
      transaction = Current.family.transactions.find(params[:transaction_id])
      entry = transaction.entry
      @transaction_template = Current.family.transaction_templates.new(
        name: entry.name,
        account_id: entry.account_id,
        amount: entry.amount.abs,
        currency: entry.currency,
        category_id: transaction.category_id,
        notes: entry.notes,
        nature: entry.amount.negative? ? "inflow" : "outflow",
        tag_ids: transaction.tags.pluck(:id)
      )
    else
      @transaction_template = Current.family.transaction_templates.new(template_params)
    end

    if @transaction_template.save
      redirect_to transaction_templates_path, notice: t("transaction_templates.create.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction_template.update(template_params)
      redirect_to transaction_templates_path, notice: t("transaction_templates.update.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction_template.destroy!
    redirect_to transaction_templates_path, notice: t("transaction_templates.destroy.deleted")
  end

  private
    def set_template
      @transaction_template = Current.family.transaction_templates.find(params[:id])
    end

    def template_params
      params.require(:transaction_template).permit(:name, :account_id, :amount, :currency, :category_id, :notes, :nature, tag_ids: [])
    end

    def template_json(template)
      template.attributes.slice("id", "name", "account_id", "amount", "currency", "category_id", "notes", "tag_ids", "nature")
    end
end
