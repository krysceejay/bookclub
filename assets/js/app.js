// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
//import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

const inner = document.getElementById('chat-body-id');
const chatForm = document.getElementById('chatareaform');
const chatInput = document.getElementById('chat-area-input');
const spinner = document.getElementById('show-ripple');
const loadMore = document.getElementById('loadmoremsg');
let bottom;
let onScroll;
let scrollHeightBefore = 0;
let Hooks = {}
Hooks.NewMessage = {
  mounted() {
    this.el.scrollTop = this.el.scrollHeight;
    this.el.addEventListener('scroll', (e) => {
      if(inner.scrollTop < 3){
        //spinner.style.display = "block";
          // setTimeout(() => {
          //   this.pushEvent("load-more", {});
          // }, 3000);
          onScroll = true;
      }
    });
    loadMore.addEventListener('click', (e) => {
      loadMore.style.display = "none";
      spinner.style.display = "block";
      setTimeout(() => {
        this.pushEvent("load-more", {});
      }, 3000);
    });

    chatForm.addEventListener("submit", () => {
      this.el.scrollTop = this.el.scrollHeight;
    });

    chatInput.addEventListener("focus", () => {
      this.el.scrollTop = this.el.scrollHeight;
    });

    window.addEventListener("resize", () => {
        this.el.scrollTop = this.el.scrollHeight;
    });

  },
  beforeUpdate(){
    scrollHeightBefore = this.el.scrollHeight;
    if(this.el.scrollTop === (this.el.scrollHeight - this.el.offsetHeight)){

      bottom = true;
    }
    else{
      bottom = false;
    }

  },
  updated(){

    if(bottom){
      this.el.scrollTop = this.el.scrollHeight;
    }

    if(onScroll){
      this.el.scrollTop = this.el.scrollHeight - scrollHeightBefore;
    }

    onScroll = false;

  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {hooks: Hooks, params: {_csrf_token: csrfToken}})
liveSocket.connect()

// Import local files
//
// Local files can be imported directly using relative paths, for example:
//import socket from "./socket"

import socket from "./chat"
