import{Controller as e}from"@hotwired/stimulus";import{useTransition as t}from"stimulus-use";class src_default extends e{initialize(){this.hide=this.hide.bind(this)}connect(){t(this);false===this.hiddenValue&&this.show()}show(){this.enter();this.timeout=setTimeout(this.hide,this.delayValue)}async hide(){this.timeout&&clearTimeout(this.timeout);await this.leave();this.element.remove()}}src_default.values={delay:{type:Number,default:3e3},hidden:{type:Boolean,default:false}};export{src_default as default};

