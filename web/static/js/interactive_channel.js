export default function initializeInteractiveChannel(socket) {
  let current_user_id = $('#current-user-id').val();

  // Now that you are connected, you can join channels with a topic:
  let ichannel = socket.channel("interactive:" + current_user_id, {});
  ichannel.join()
      .receive("ok", resp => {
        console.log("Joined successfully", resp)
      })
      .receive("error", resp => {
        console.log("Unable to join", resp)
      });

  return ichannel;
}
