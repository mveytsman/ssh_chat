<template>
  <div class="message">
    <span class="username">{{ message.user }}</span> {{ message.text }}
  </div>
</template>

<script>
export default {
  name: "message",
  props: ["message"],
  data() {
    return {}
  },
}
</script>

<style lang="scss">
  .username::after {
    padding-right: .1rem;
    content: ":";
  }
</style>