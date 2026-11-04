# Dedicated Telegram account setup

BitWave is configured for a separate Telegram account used only as a personal music library account.

## Recommended account setup

1. Create or sign in to the separate Telegram account using Telegram's official app.
2. Enable a strong two-step verification password and recovery email.
3. Create a private channel named something recognizable, such as "BitWave Music".
4. Keep the channel private. Do not add public usernames unless you intentionally want it discoverable.
5. Upload music you own or are authorized to store and play.
6. Invite the dedicated account to any other private channels or groups it should index. It can only read chats the account itself can access.
7. Create an application at https://my.telegram.org/apps and use that app's API ID and API hash for TDLib.

## BitWave onboarding

The planned onboarding flow will:
- accept the Telegram API ID and API hash locally;
- start TDLib authorization and request a phone number;
- ask for Telegram's login code and, if enabled, the two-step verification password;
- display accessible chats and let the user select sources;
- offer to create/use a private BitWave music channel (creation requires the account to be authorized and the native adapter to support the appropriate TDLib operation);
- index supported audio and document messages from selected sources.

BitWave must never ask users to paste login codes or two-step passwords into chat, websites, or support tickets. They are entered only into the local application and passed to TDLib. Never log these values.

## Account safety

A TDLib client session has account-level access, not just access to selected music chats. Keep the session on a trusted device, use OS-backed secure storage for credentials and database keys, and revoke the session from Telegram Settings → Devices if a device is lost or compromised.

## Storage reality

Telegram cloud files are not guaranteed unlimited storage or bandwidth. File size, account eligibility, platform/API limits, network conditions, and Telegram policy apply. BitWave must display failures and flood waits honestly, and never try to bypass access controls or rate limits.
