/**
 * @namespace flexygo.ui.wc
 */
var flexygo;
(function (flexygo) {
    var ui;
    (function (ui) {
        var wc;
        (function (wc) {
            /**
            * Library for the FlxSampleWcElement
            *
            * @class FlxSampleWcElement
            * @constructor
            * @return {FlxSampleWcElement} .
            */
            class FlxNavButtonElement extends HTMLElement {
                constructor() {
                    //If a constructor is defined, is REQUIRED call the super constructor
                    super();
                    /**
                    * Set if element has been connected to DOM
                    * @property connected {boolean}
                    */
                    this.connected = false;
                    /**
                   *Include navigation in history
                   * @property excludehist {boolean}
                   */
                    this.excludehist = false;
                    /**
                    * Show Progress in process
                    * @property showProgress {boolean}
                    */
                    this.showprogress = true;
                }
                /**
                * Array of observed attributes. REQUIRED
                * @property observedAttributes {Array}
                */
                static get observedAttributes() {
                    return ['type', 'objectname', 'objectwhere', 'defaults', 'targetid', 'excludehist', 'pagename', 'pagetypeid', 'callback', 'processname', 'processparams', 'reportname', 'reportwhere', 'reportparams', 'helpid', 'showProgress'];
                }
                /**
               * Fires when element is attached to DOM
               * @method connectedCallback
               */
                connectedCallback() {
                    let element = $(this);
                    this.type = element.attr("type");
                    this.objectname = element.attr("objectname") || null;
                    this.objectwhere = element.attr("objectwhere") || null;
                    this.defaults = element.attr("defaults") || null;
                    this.targetid = element.attr("targetid") || 'current';
                    if (element.attr("excludehist")) {
                        this.excludehist = (element.attr("excludehist").toLowerCase() == 'true');
                    }
                    this.pagename = element.attr("pagename") || null;
                    this.pagetypeid = element.attr("pagetypeid");
                    this.callback = element.attr("callback") || null;
                    this.processname = element.attr("processname") || null;
                    this.processparams = element.attr("processparams") || null;
                    this.reportname = element.attr("reportname") || null;
                    this.reportwhere = element.attr("reportwhere") || null;
                    this.reportparams = element.attr("reportparams") || null;
                    this.helpid = element.attr("helpid") || null;
                    if (element.attr("showprogress")) {
                        this.showprogress = (element.attr("showprogress").toLowerCase() == 'true');
                    }
                    this.connected = true;
                    this.init();
                }
                /**
                * Fires when the attribute value of the element is changed.
                * @method attributeChangedCallback
                */
                attributeChangedCallback(attrName, oldVal, newVal) {
                    let needInit = false;
                    if (attrName.toLowerCase() == 'type' && newVal && newVal != '') {
                        this.type = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'objectname' && newVal && newVal != '') {
                        this.objectname = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'objectwhere' && newVal && newVal != '') {
                        this.objectwhere = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'defaults' && newVal && newVal != '') {
                        this.defaults = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'targetid' && newVal && newVal != '') {
                        this.targetid = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'excludehist' && newVal && newVal != '') {
                        this.excludehist = (newVal.toLowerCase() == 'true');
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'pagename' && newVal && newVal != '') {
                        this.pagename = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'pagetypeid' && newVal && newVal != '') {
                        this.pagetypeid = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'callback' && newVal && newVal != '') {
                        this.callback = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'processname' && newVal && newVal != '') {
                        this.processname = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'reportname' && newVal && newVal != '') {
                        this.reportname = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'reportwhere' && newVal && newVal != '') {
                        this.reportwhere = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'reportparams' && newVal && newVal != '') {
                        this.reportparams = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'helpid' && newVal && newVal != '') {
                        this.helpid = newVal;
                        needInit = true;
                    }
                    else if (attrName.toLowerCase() == 'showprogress' && newVal && newVal != '') {
                        this.showprogress = (newVal.toLowerCase() == 'true');
                        needInit = true;
                    }
                    if (this.connected && needInit) {
                        this.init();
                    }
                }
                /**
                * Init the webcomponent.
                * @method init
                */
                init() {
                    this.render();
                }
                /**
                * Refresh de webcomponent.
                * @method refresh
                */
                refresh() {
                    this.render();
                }
                /**
                * Render HTML data.
                * @method render
                */
                render() {
                    let me = $(this);
                    me.off('click').on('click', (ev) => {
                        ev.stopPropagation();
                        ev.preventDefault();
                        switch (this.type.toLocaleLowerCase()) {
                            case "openpage":
                                flexygo.nav.openPage(this.pagetypeid, this.objectname, this.objectwhere, this.defaults, this.targetid, this.excludehist, me);
                                break;
                            case "openpagename":
                                flexygo.nav.openPageName(this.pagename, this.objectname, this.objectwhere, this.defaults, this.targetid, this.excludehist, me);
                                break;
                            case "execprocess":
                                flexygo.nav.execProcess(this.processname, this.objectname, this.objectwhere, this.defaults, this.processparams, this.targetid, this.excludehist, me, this.callback, this.showprogress);
                                break;
                            case "openprocessparams":
                                flexygo.nav.openProcessParams(this.processname, this.objectname, this.objectwhere, this.defaults, this.targetid, this.excludehist, me);
                                break;
                            case "openprocessparamspage":
                                flexygo.nav.openProcessParamsPage(this.pagename, this.processname, this.objectname, this.objectwhere, this.defaults, this.targetid, this.excludehist, me);
                                break;
                            case "openreportsparams":
                                flexygo.nav.openReportsParams(this.reportname, this.reportwhere, this.objectname, this.objectwhere, this.defaults, this.targetid, this.excludehist, me);
                                break;
                            case "openreportsparamspage":
                                flexygo.nav.openReportsParamsPage(this.pagename, this.reportname, this.reportwhere, this.objectname, this.objectwhere, this.defaults, this.targetid, this.excludehist, me);
                                break;
                            case "viewreport":
                                flexygo.nav.viewReport(this.reportname, this.reportwhere, this.objectname, this.objectwhere, this.defaults, this.reportparams, this.targetid, this.excludehist);
                                break;
                            case "openhelpid":
                                flexygo.nav.openHelpId(this.helpid, this.targetid, this.excludehist, me);
                                break;
                            default:
                                alert('type not implemented');
                                break;
                        }
                    });
                }
            }
            wc.FlxNavButtonElement = FlxNavButtonElement;
        })(wc = ui.wc || (ui.wc = {}));
    })(ui = flexygo.ui || (flexygo.ui = {}));
})(flexygo || (flexygo = {}));
window.customElements.define("flx-navbutton", flexygo.ui.wc.FlxNavButtonElement);
//# sourceMappingURL=flx-navbutton.js.map