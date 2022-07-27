local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
        return
end

local actions = require "telescope.actions"

telescope.setup {
        defaults = {

                prompt_prefix = " ",
                selection_caret = " ",
                path_display = { "smart" },
                file_ignore_patterns = { ".git/", "node_modules" },

                mappings = {
                        i = {
                                ["<Down>"] = actions.cycle_history_next,
                                ["<Up>"] = actions.cycle_history_prev,
                                ["<C-j>"] = actions.move_selection_next,
                                ["<C-k>"] = actions.move_selection_previous,
                        },
                },
        },
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension('fzf')

-- Load git worktree extensions
telescope.load_extension('git_worktree')
