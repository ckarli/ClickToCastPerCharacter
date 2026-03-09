# ClickToCastPerCharacter

A World of Warcraft addon that saves and restores the "Hold to Cast" setting on a per-character basis.

## Features

- Automatically saves your Hold to Cast preference for each character
- Restores the setting when you log in
- Works across all characters on all realms
- Simple slash commands for quick control

## Installation

1. Download or clone this repository
2. Copy the `ClickToCastPerCharacter` folder to your WoW addons directory:
   - **Retail**: `World of Warcraft/_retail_/Interface/AddOns/`
   - **Classic**: `World of Warcraft/_classic_/Interface/AddOns/`
3. Restart WoW or reload your UI (`/reload`)

## Usage

### Slash Commands

| Command | Description |
|---------|-------------|
| `/ctc` | Show current Hold to Cast status |
| `/ctc on` | Enable Hold to Cast for this character |
| `/ctc off` | Disable Hold to Cast for this character |
| `/ctc toggle` | Toggle Hold to Cast setting |
| `/ctc status` | Show current status |
| `/ctc help` | Show all available commands |

Alternative slash commands: `/clicktocast`, `/holdtocast`

## How It Works

The addon uses the `ActionButtonUseKeyHeldSpell` CVar to control the Hold to Cast behavior. When you log in, it automatically applies your saved preference for that specific character. Settings are saved per character (Name-Realm format) so each of your characters can have different preferences.

## License

MIT License - Feel free to use and modify as needed.
