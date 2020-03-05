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
const spinner = document.getElementById('show-ripple');
let bottom;
let Hooks = {}
Hooks.NewMessage = {
  mounted() {
    this.el.scrollTop = this.el.scrollHeight;
    this.el.addEventListener('scroll', (e) => {
      if(inner.scrollTop < 1){
        spinner.style.display = "block";
          setTimeout(() => {
            this.pushEvent("load-more", {});
          }, 3000);
      }
      //spinner.style.display = "none";
    });

  },
  beforeUpdate(){
    this.el.addEventListener('scroll', (e) => {
      console.log(this.el.scrollTop);
      console.log(this.el.scrollHeight - this.el.offsetHeight);
      if(this.el.scrollTop === (this.el.scrollHeight - this.el.offsetHeight)){
        // this.el.scrollTop += 1000;

        bottom = true;
        console.log('yes');
      }
      else{
        // this.el.scrollTop = 10;
        bottom = false;
        console.log('no');
      }
    });
    // if(this.el.scrollTop === (this.el.scrollHeight - this.el.offsetHeight)){
    //   // this.el.scrollTop += 1000;
    //   // console.log(this.el.scrollTop);
    //   // console.log(this.el.scrollHeight);
    //   bottom = true;
    //   //console.log('yes');
    // }
    // else{
    //   // this.el.scrollTop = 10;
    //   bottom = false;
    //   //console.log('no');
    // }

    console.log("from before "+bottom);
  },
  updated(){
    console.log("from update "+bottom);
    if(bottom){
      this.el.scrollTop = this.el.scrollHeight;
    }else{
      this.el.scrollTop = 5;
    }

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
