-- Add systemd file types
vim.filetype.add({
	extension = {
		timer = "systemd",
		service = "systemd",
		automount = "systemd",
		mount = "systemd",
		target = "systemd",
		path = "systemd",
	},
	pattern = {
		[".*/etc/systemd/.*.%.socket"] = "systemd",
		[".*/etc/systemd/.*.%.swap"] = "systemd",
		[".*/etc/systemd/.*.%.conf"] = "systemd",
		[".*/etc/systemd/.*.d/*.%.conf"] = "systemd",
		[".*/etc/systemd/.*.d/.#.*"] = "systemd",
		["~/.config/systemd/user/.*.%.socket"] = "systemd",
		["~/.config/systemd/user/.*.%.swap"] = "systemd",
	},
})
