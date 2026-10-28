import Gio from 'gi://Gio';

import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import {State} from 'resource:///org/gnome/shell/ui/messageTray.js';

const OBJECT_PATH = '/org/gnome/Shell/Extensions/DismissNotification';
const INTERFACE = `
<node>
  <interface name="org.gnome.Shell.Extensions.DismissNotification">
    <method name="Dismiss">
      <arg name="dismissed" type="b" direction="out"/>
    </method>
  </interface>
</node>`;

export default class DismissNotificationExtension extends Extension {
    enable() {
        this._dbus = Gio.DBusExportedObject.wrapJSObject(INTERFACE, this);
        this._dbus.export(Gio.DBus.session, OBJECT_PATH);
    }

    disable() {
        this._dbus?.unexport();
        this._dbus = null;
    }

    Dismiss() {
        const tray = Main.messageTray;

        // Do not touch history-only, queued, hidden, or already-closing notifications.
        // These private fields are checked against GNOME Shell 50's messageTray.js.
        if (Main.sessionMode.isLocked || !Main.sessionMode.hasNotifications ||
            !tray.visible || tray._bannerBlocked || tray._notificationRemoved ||
            ![State.SHOWING, State.SHOWN].includes(tray._notificationState) ||
            !tray._notification || !tray._banner)
            return false;

        tray._banner.close();

        // A zero-duration hide can complete inside _updateState(), where its
        // reentrancy guard blocks advancing the queue. Retry after close returns.
        tray._updateState();
        return true;
    }
}
