local status_ok, gitworktree = pcall(require, "git-worktree")
if not status_ok then
  return
end

gitworktree.setup({
--    change_directory_command = <str> -- default: "cd",
--    update_on_change = <boolean> -- default: true,
--    update_on_change_command = <str> -- default: "e .",
--    clearjumps_on_change = <boolean> -- default: true,
--    autopush = <boolean> -- default: false,
})
