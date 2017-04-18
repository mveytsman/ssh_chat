<template>
  <div>
    <message v-for="m in messages"
             v-bind:message="m"
             :key="m.id" />
    <input v-model="new_message"
           v-on:keyup.enter="add_message"
           v-on:keydown="clear_error">
    <button v-on:click="add_message">Message</button>
    <p class="error" v-if="error">you have to send a message</p>  
  </div>
</template>

<script>
import Message from './Message.vue'
export default {
  name: 'message-list',
  data() {
    return {
      error: false,
      username: "anonymous",
      new_message: "",
      messages: []
    }
  },
  methods: {
    clear_error: function () {
      if (this.error) {
        this.error = false
      }
    },

    add_message: function () {
      if (this.new_message != "") {
        this.messages.push(
          {
            text: this.new_message,
            id: Date.now(),
            user: this.username
          }
        )
        this.new_message = ""
      } else {
        this.error = true
      }
    }
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
</style>