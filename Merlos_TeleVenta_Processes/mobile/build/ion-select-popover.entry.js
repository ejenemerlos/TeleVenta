import { r as registerInstance, j as h, l as Host } from './index-76f52202.js';
import { g as getIonMode } from './ionic-global-693c5dc1.js';
import './hardware-back-button-c2d005b0.js';
import { s as safeCall } from './overlays-39d86a31.js';
import { g as getClassMap } from './theme-86cb12f9.js';

const selectPopoverCss = ".sc-ion-select-popover-h ion-list.sc-ion-select-popover{margin-left:0;margin-right:0;margin-top:-1px;margin-bottom:-1px}.sc-ion-select-popover-h ion-list-header.sc-ion-select-popover,.sc-ion-select-popover-h ion-label.sc-ion-select-popover{margin-left:0;margin-right:0;margin-top:0;margin-bottom:0}";

const SelectPopover = class {
    constructor(hostRef) {
        registerInstance(this, hostRef);
        /** Array of options for the popover */
        this.options = [];
    }
    onSelect(ev) {
        const option = this.options.find(o => o.value === ev.target.value);
        if (option) {
            safeCall(option.handler);
        }
    }
    render() {
        const checkedOption = this.options.find(o => o.checked);
        const checkedValue = checkedOption ? checkedOption.value : undefined;
        return (h(Host, { class: getIonMode(this) }, h("ion-list", null, this.header !== undefined && h("ion-list-header", null, this.header), (this.subHeader !== undefined || this.message !== undefined) &&
            h("ion-item", null, h("ion-label", { class: "ion-text-wrap" }, this.subHeader !== undefined && h("h3", null, this.subHeader), this.message !== undefined && h("p", null, this.message))), h("ion-radio-group", { value: checkedValue }, this.options.map(option => h("ion-item", { class: getClassMap(option.cssClass) }, h("ion-label", null, option.text), h("ion-radio", { value: option.value, disabled: option.disabled })))))));
    }
};
SelectPopover.style = selectPopoverCss;

export { SelectPopover as ion_select_popover };
