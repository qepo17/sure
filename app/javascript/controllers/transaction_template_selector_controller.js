import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["select", "filter", "name", "amount", "account", "category", "notes", "nature"];

  filter() {
    const term = this.filterTarget.value.toLowerCase();
    Array.from(this.selectTarget.options).forEach((option) => {
      if (option.value === "") return;
      option.hidden = !option.text.toLowerCase().includes(term);
    });
  }

  apply() {
    const id = this.selectTarget.value;
    if (!id) return;

    fetch(`/transaction_templates/${id}.json`)
      .then((r) => r.json())
      .then((data) => {
        if (this.hasNameTarget) this.nameTarget.value = data.name || "";
        if (this.hasAmountTarget) this.amountTarget.value = data.amount;
        if (this.hasNotesTarget) this.notesTarget.value = data.notes || "";
        if (this.hasNatureTarget) this.natureTarget.value = data.nature;

        this.accountTargets.forEach((el) => {
          el.value = data.account_id || "";
          el.dispatchEvent(new Event("change", { bubbles: true }));
        });
        this.categoryTargets.forEach((el) => {
          el.value = data.category_id || "";
          el.dispatchEvent(new Event("change", { bubbles: true }));
        });
      });
  }
}
