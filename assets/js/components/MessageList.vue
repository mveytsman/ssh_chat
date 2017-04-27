<template>
  <div>
    <message v-for="m in messages"
             v-bind:message="m"
             :key="m.id" />
     <div class="message-input">
     <input
       v-model="new_message"
       v-on:keyup.enter="add_message"
       v-on:keydown="clear_error">
      <button v-on:click="add_message">Message</button>
      <p class="error" v-if="error">you have to send a message</p>
    </div>
  </div>
</template>

<script>
import { Socket } from "phoenix"
import Message from './Message.vue'
export default {
  name: 'message-list',
  data() {
    return {
      socket: null,
      channel: null,
      error: false,
      username: "anonymous",
      new_message: "",
      messages: []
    }
  },
  methods: {
    clear_error() {
      if (this.error) {
        this.error = false
      }
    },

    add_message() {
      if (this.new_message != "") {
        let msg = {
          body: this.new_message,
          id: Date.now(),
          user: this.username
        }
        // this.messages.push(msg)
        this.channel.push("new_msg", msg)
        this.new_message = ""
      } else {
        this.error = true
      }
    }
  },
  mounted() {
    this.socket = new Socket("/socket")
    this.socket.connect()
    this.channel = this.socket.channel("room:lobby", {});
    this.channel.on("new_msg", payload => {
      payload.received_at = Date();
      this.messages.push(payload);
    });
    this.channel.join()
      .receive("ok", response => { console.log("Joined successfully", response) })
      .receive("error", response => { console.log("Unable to join", response) })
  },
  components: {
    Message
  }
}
</script>

<style lang="scss">
.error::before {
  padding-right: .2rem;
  content: "error:";
}

.message-input {
  margin-top: 1rem;
}
</style>
