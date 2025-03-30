#region enums
enum PowerToysConfigureEnsure {
    Absent
    Present
}

enum AwakeMode {
    PASSIVE = 1
    INDEFINITE
    TIMED
    EXPIRABLE
}

enum ColorPickerActivationAction {
    OpenEditor = 1
    OpenColorPickerAndThenEditor
    OpenOnlyColorPicker
}

enum HostsAdditionalLinesPosition {
    Top = 1
    Bottom
}

enum HostsEncoding {
    Utf8 = 1
    Utf8Bom
}

enum PowerAccentActivationKey {
    LeftRightArrow = 1
    Space
    Both
}

enum Theme {
    System = 1
    Light
    Dark
    HighContrastOne
    HighContrastTwo
    HighContrastBlack
    HighContrastWhite
}

enum StartupPosition {
    Cursor = 1
    PrimaryMonitor
    Focus
}

enum SortByProperty {
    LastLaunched = 1
    Created
    Name
}
#endregion enums

#region DscResources
class AdvancedPaste {
    [DscProperty()] [Nullable[bool]]
    $IsAdvancedAIEnabled = $null

    [DscProperty()] [Nullable[bool]]
    $ShowCustomPreview = $null

    [DscProperty()] [Nullable[bool]]
    $CloseAfterLosingFocus = $null

    [DscProperty()] [string]
    $AdvancedPasteUIShortcut = $null

    [DscProperty()] [string]
    $PasteAsPlainTextShortcut = $null

    [DscProperty()] [string]
    $PasteAsMarkdownShortcut = $null

    [DscProperty()] [string]
    $PasteAsJsonShortcut = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.IsAdvancedAIEnabled -ne $null) {
            $Changes.Value += "set AdvancedPaste.IsAdvancedAIEnabled `"$($this.IsAdvancedAIEnabled)`""
        }

        if ($this.ShowCustomPreview -ne $null) {
            $Changes.Value += "set AdvancedPaste.ShowCustomPreview `"$($this.ShowCustomPreview)`""
        }

        if ($this.CloseAfterLosingFocus -ne $null) {
            $Changes.Value += "set AdvancedPaste.CloseAfterLosingFocus `"$($this.CloseAfterLosingFocus)`""
        }

        if ($this.AdvancedPasteUIShortcut -notlike '') {
            $Changes.Value += "set AdvancedPaste.AdvancedPasteUIShortcut `"$($this.AdvancedPasteUIShortcut)`""
        }

        if ($this.PasteAsPlainTextShortcut -notlike '') {
            $Changes.Value += "set AdvancedPaste.PasteAsPlainTextShortcut `"$($this.PasteAsPlainTextShortcut)`""
        }

        if ($this.PasteAsMarkdownShortcut -notlike '') {
            $Changes.Value += "set AdvancedPaste.PasteAsMarkdownShortcut `"$($this.PasteAsMarkdownShortcut)`""
        }

        if ($this.PasteAsJsonShortcut -notlike '') {
            $Changes.Value += "set AdvancedPaste.PasteAsJsonShortcut `"$($this.PasteAsJsonShortcut)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.AdvancedPaste `"$($this.Enabled)`""
        }


    }
}
class AlwaysOnTop {
    [DscProperty()] [string]
    $Hotkey = $null

    [DscProperty()] [string]
    $FrameEnabled = $null

    [DscProperty()] [Nullable[int]]
    $FrameThickness = $null

    [DscProperty()] [string]
    $FrameColor = $null

    [DscProperty()] [Nullable[int]]
    $FrameOpacity = $null

    [DscProperty()] [string]
    $FrameAccentColor = $null

    [DscProperty()] [string]
    $SoundEnabled = $null

    [DscProperty()] [string]
    $DoNotActivateOnGameMode = $null

    [DscProperty()] [string]
    $ExcludedApps = $null

    [DscProperty()] [string]
    $RoundCornersEnabled = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.Hotkey -notlike '') {
            $Changes.Value += "set AlwaysOnTop.Hotkey `"$($this.Hotkey)`""
        }

        if ($this.FrameEnabled -notlike '') {
            $Changes.Value += "set AlwaysOnTop.FrameEnabled `"$($this.FrameEnabled)`""
        }

        if ($this.FrameThickness -ne $null) {
            $Changes.Value += "set AlwaysOnTop.FrameThickness `"$($this.FrameThickness)`""
        }

        if ($this.FrameColor -notlike '') {
            $Changes.Value += "set AlwaysOnTop.FrameColor `"$($this.FrameColor)`""
        }

        if ($this.FrameOpacity -ne $null) {
            $Changes.Value += "set AlwaysOnTop.FrameOpacity `"$($this.FrameOpacity)`""
        }

        if ($this.FrameAccentColor -notlike '') {
            $Changes.Value += "set AlwaysOnTop.FrameAccentColor `"$($this.FrameAccentColor)`""
        }

        if ($this.SoundEnabled -notlike '') {
            $Changes.Value += "set AlwaysOnTop.SoundEnabled `"$($this.SoundEnabled)`""
        }

        if ($this.DoNotActivateOnGameMode -notlike '') {
            $Changes.Value += "set AlwaysOnTop.DoNotActivateOnGameMode `"$($this.DoNotActivateOnGameMode)`""
        }

        if ($this.ExcludedApps -notlike '') {
            $Changes.Value += "set AlwaysOnTop.ExcludedApps `"$($this.ExcludedApps)`""
        }

        if ($this.RoundCornersEnabled -notlike '') {
            $Changes.Value += "set AlwaysOnTop.RoundCornersEnabled `"$($this.RoundCornersEnabled)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.AlwaysOnTop `"$($this.Enabled)`""
        }


    }
}
class Awake {
    [DscProperty()] [Nullable[bool]]
    $KeepDisplayOn = $null

    [DscProperty()] [AwakeMode]
    $Mode 

    [DscProperty()] [Nullable[int]]
    $IntervalHours = $null

    [DscProperty()] [Nullable[int]]
    $IntervalMinutes = $null

    [DscProperty()] [string]
    $ExpirationDateTime = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.KeepDisplayOn -ne $null) {
            $Changes.Value += "set Awake.KeepDisplayOn `"$($this.KeepDisplayOn)`""
        }

        if ($this.Mode -ne 0) {
            $Changes.Value += "set Awake.Mode `"$($this.Mode)`""
        }

        if ($this.IntervalHours -ne $null) {
            $Changes.Value += "set Awake.IntervalHours `"$($this.IntervalHours)`""
        }

        if ($this.IntervalMinutes -ne $null) {
            $Changes.Value += "set Awake.IntervalMinutes `"$($this.IntervalMinutes)`""
        }

        if ($this.ExpirationDateTime -notlike '') {
            $Changes.Value += "set Awake.ExpirationDateTime `"$($this.ExpirationDateTime)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.Awake `"$($this.Enabled)`""
        }


    }
}
class ColorPicker {
    [DscProperty()] [string]
    $ActivationShortcut = $null

    [DscProperty()] [string]
    $CopiedColorRepresentation = $null

    [DscProperty()] [ColorPickerActivationAction]
    $ActivationAction 

    [DscProperty()] [Nullable[bool]]
    $ShowColorName = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationShortcut -notlike '') {
            $Changes.Value += "set ColorPicker.ActivationShortcut `"$($this.ActivationShortcut)`""
        }

        if ($this.CopiedColorRepresentation -notlike '') {
            $Changes.Value += "set ColorPicker.CopiedColorRepresentation `"$($this.CopiedColorRepresentation)`""
        }

        if ($this.ActivationAction -ne 0) {
            $Changes.Value += "set ColorPicker.ActivationAction `"$($this.ActivationAction)`""
        }

        if ($this.ShowColorName -ne $null) {
            $Changes.Value += "set ColorPicker.ShowColorName `"$($this.ShowColorName)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.ColorPicker `"$($this.Enabled)`""
        }


    }
}
class CropAndLock {
    [DscProperty()] [string]
    $ReparentHotkey = $null

    [DscProperty()] [string]
    $ThumbnailHotkey = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ReparentHotkey -notlike '') {
            $Changes.Value += "set CropAndLock.ReparentHotkey `"$($this.ReparentHotkey)`""
        }

        if ($this.ThumbnailHotkey -notlike '') {
            $Changes.Value += "set CropAndLock.ThumbnailHotkey `"$($this.ThumbnailHotkey)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.CropAndLock `"$($this.Enabled)`""
        }


    }
}
class EnvironmentVariables {
    [DscProperty()] [Nullable[bool]]
    $LaunchAdministrator = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.LaunchAdministrator -ne $null) {
            $Changes.Value += "set EnvironmentVariables.LaunchAdministrator `"$($this.LaunchAdministrator)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.EnvironmentVariables `"$($this.Enabled)`""
        }


    }
}
class FancyZones {
    [DscProperty()] [string]
    $FancyzonesShiftDrag = $null

    [DscProperty()] [string]
    $FancyzonesMouseSwitch = $null

    [DscProperty()] [string]
    $FancyzonesMouseMiddleClickSpanningMultipleZones = $null

    [DscProperty()] [string]
    $FancyzonesOverrideSnapHotkeys = $null

    [DscProperty()] [string]
    $FancyzonesMoveWindowsAcrossMonitors = $null

    [DscProperty()] [string]
    $FancyzonesMoveWindowsBasedOnPosition = $null

    [DscProperty()] [Nullable[int]]
    $FancyzonesOverlappingZonesAlgorithm = $null

    [DscProperty()] [string]
    $FancyzonesDisplayOrWorkAreaChangeMoveWindows = $null

    [DscProperty()] [string]
    $FancyzonesZoneSetChangeMoveWindows = $null

    [DscProperty()] [string]
    $FancyzonesAppLastZoneMoveWindows = $null

    [DscProperty()] [string]
    $FancyzonesOpenWindowOnActiveMonitor = $null

    [DscProperty()] [string]
    $FancyzonesRestoreSize = $null

    [DscProperty()] [string]
    $FancyzonesQuickLayoutSwitch = $null

    [DscProperty()] [string]
    $FancyzonesFlashZonesOnQuickSwitch = $null

    [DscProperty()] [string]
    $UseCursorposEditorStartupscreen = $null

    [DscProperty()] [string]
    $FancyzonesShowOnAllMonitors = $null

    [DscProperty()] [string]
    $FancyzonesSpanZonesAcrossMonitors = $null

    [DscProperty()] [string]
    $FancyzonesMakeDraggedWindowTransparent = $null

    [DscProperty()] [string]
    $FancyzonesAllowChildWindowSnap = $null

    [DscProperty()] [string]
    $FancyzonesDisableRoundCornersOnSnap = $null

    [DscProperty()] [string]
    $FancyzonesZoneHighlightColor = $null

    [DscProperty()] [Nullable[int]]
    $FancyzonesHighlightOpacity = $null

    [DscProperty()] [string]
    $FancyzonesEditorHotkey = $null

    [DscProperty()] [string]
    $FancyzonesWindowSwitching = $null

    [DscProperty()] [string]
    $FancyzonesNextTabHotkey = $null

    [DscProperty()] [string]
    $FancyzonesPrevTabHotkey = $null

    [DscProperty()] [string]
    $FancyzonesExcludedApps = $null

    [DscProperty()] [string]
    $FancyzonesBorderColor = $null

    [DscProperty()] [string]
    $FancyzonesInActiveColor = $null

    [DscProperty()] [string]
    $FancyzonesNumberColor = $null

    [DscProperty()] [string]
    $FancyzonesSystemTheme = $null

    [DscProperty()] [string]
    $FancyzonesShowZoneNumber = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.FancyzonesShiftDrag -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesShiftDrag `"$($this.FancyzonesShiftDrag)`""
        }

        if ($this.FancyzonesMouseSwitch -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesMouseSwitch `"$($this.FancyzonesMouseSwitch)`""
        }

        if ($this.FancyzonesMouseMiddleClickSpanningMultipleZones -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesMouseMiddleClickSpanningMultipleZones `"$($this.FancyzonesMouseMiddleClickSpanningMultipleZones)`""
        }

        if ($this.FancyzonesOverrideSnapHotkeys -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesOverrideSnapHotkeys `"$($this.FancyzonesOverrideSnapHotkeys)`""
        }

        if ($this.FancyzonesMoveWindowsAcrossMonitors -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesMoveWindowsAcrossMonitors `"$($this.FancyzonesMoveWindowsAcrossMonitors)`""
        }

        if ($this.FancyzonesMoveWindowsBasedOnPosition -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesMoveWindowsBasedOnPosition `"$($this.FancyzonesMoveWindowsBasedOnPosition)`""
        }

        if ($this.FancyzonesOverlappingZonesAlgorithm -ne $null) {
            $Changes.Value += "set FancyZones.FancyzonesOverlappingZonesAlgorithm `"$($this.FancyzonesOverlappingZonesAlgorithm)`""
        }

        if ($this.FancyzonesDisplayOrWorkAreaChangeMoveWindows -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesDisplayOrWorkAreaChangeMoveWindows `"$($this.FancyzonesDisplayOrWorkAreaChangeMoveWindows)`""
        }

        if ($this.FancyzonesZoneSetChangeMoveWindows -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesZoneSetChangeMoveWindows `"$($this.FancyzonesZoneSetChangeMoveWindows)`""
        }

        if ($this.FancyzonesAppLastZoneMoveWindows -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesAppLastZoneMoveWindows `"$($this.FancyzonesAppLastZoneMoveWindows)`""
        }

        if ($this.FancyzonesOpenWindowOnActiveMonitor -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesOpenWindowOnActiveMonitor `"$($this.FancyzonesOpenWindowOnActiveMonitor)`""
        }

        if ($this.FancyzonesRestoreSize -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesRestoreSize `"$($this.FancyzonesRestoreSize)`""
        }

        if ($this.FancyzonesQuickLayoutSwitch -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesQuickLayoutSwitch `"$($this.FancyzonesQuickLayoutSwitch)`""
        }

        if ($this.FancyzonesFlashZonesOnQuickSwitch -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesFlashZonesOnQuickSwitch `"$($this.FancyzonesFlashZonesOnQuickSwitch)`""
        }

        if ($this.UseCursorposEditorStartupscreen -notlike '') {
            $Changes.Value += "set FancyZones.UseCursorposEditorStartupscreen `"$($this.UseCursorposEditorStartupscreen)`""
        }

        if ($this.FancyzonesShowOnAllMonitors -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesShowOnAllMonitors `"$($this.FancyzonesShowOnAllMonitors)`""
        }

        if ($this.FancyzonesSpanZonesAcrossMonitors -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesSpanZonesAcrossMonitors `"$($this.FancyzonesSpanZonesAcrossMonitors)`""
        }

        if ($this.FancyzonesMakeDraggedWindowTransparent -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesMakeDraggedWindowTransparent `"$($this.FancyzonesMakeDraggedWindowTransparent)`""
        }

        if ($this.FancyzonesAllowChildWindowSnap -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesAllowChildWindowSnap `"$($this.FancyzonesAllowChildWindowSnap)`""
        }

        if ($this.FancyzonesDisableRoundCornersOnSnap -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesDisableRoundCornersOnSnap `"$($this.FancyzonesDisableRoundCornersOnSnap)`""
        }

        if ($this.FancyzonesZoneHighlightColor -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesZoneHighlightColor `"$($this.FancyzonesZoneHighlightColor)`""
        }

        if ($this.FancyzonesHighlightOpacity -ne $null) {
            $Changes.Value += "set FancyZones.FancyzonesHighlightOpacity `"$($this.FancyzonesHighlightOpacity)`""
        }

        if ($this.FancyzonesEditorHotkey -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesEditorHotkey `"$($this.FancyzonesEditorHotkey)`""
        }

        if ($this.FancyzonesWindowSwitching -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesWindowSwitching `"$($this.FancyzonesWindowSwitching)`""
        }

        if ($this.FancyzonesNextTabHotkey -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesNextTabHotkey `"$($this.FancyzonesNextTabHotkey)`""
        }

        if ($this.FancyzonesPrevTabHotkey -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesPrevTabHotkey `"$($this.FancyzonesPrevTabHotkey)`""
        }

        if ($this.FancyzonesExcludedApps -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesExcludedApps `"$($this.FancyzonesExcludedApps)`""
        }

        if ($this.FancyzonesBorderColor -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesBorderColor `"$($this.FancyzonesBorderColor)`""
        }

        if ($this.FancyzonesInActiveColor -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesInActiveColor `"$($this.FancyzonesInActiveColor)`""
        }

        if ($this.FancyzonesNumberColor -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesNumberColor `"$($this.FancyzonesNumberColor)`""
        }

        if ($this.FancyzonesSystemTheme -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesSystemTheme `"$($this.FancyzonesSystemTheme)`""
        }

        if ($this.FancyzonesShowZoneNumber -notlike '') {
            $Changes.Value += "set FancyZones.FancyzonesShowZoneNumber `"$($this.FancyzonesShowZoneNumber)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.FancyZones `"$($this.Enabled)`""
        }


    }
}
class FileLocksmith {
    [DscProperty()] [string]
    $ExtendedContextMenuOnly = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ExtendedContextMenuOnly -notlike '') {
            $Changes.Value += "set FileLocksmith.ExtendedContextMenuOnly `"$($this.ExtendedContextMenuOnly)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.FileLocksmith `"$($this.Enabled)`""
        }


    }
}
class FindMyMouse {
    [DscProperty()] [Nullable[int]]
    $ActivationMethod = $null

    [DscProperty()] [string]
    $IncludeWinKey = $null

    [DscProperty()] [string]
    $ActivationShortcut = $null

    [DscProperty()] [string]
    $DoNotActivateOnGameMode = $null

    [DscProperty()] [string]
    $BackgroundColor = $null

    [DscProperty()] [string]
    $SpotlightColor = $null

    [DscProperty()] [Nullable[int]]
    $OverlayOpacity = $null

    [DscProperty()] [Nullable[int]]
    $SpotlightRadius = $null

    [DscProperty()] [Nullable[int]]
    $AnimationDurationMs = $null

    [DscProperty()] [Nullable[int]]
    $SpotlightInitialZoom = $null

    [DscProperty()] [string]
    $ExcludedApps = $null

    [DscProperty()] [Nullable[int]]
    $ShakingMinimumDistance = $null

    [DscProperty()] [Nullable[int]]
    $ShakingIntervalMs = $null

    [DscProperty()] [Nullable[int]]
    $ShakingFactor = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationMethod -ne $null) {
            $Changes.Value += "set FindMyMouse.ActivationMethod `"$($this.ActivationMethod)`""
        }

        if ($this.IncludeWinKey -notlike '') {
            $Changes.Value += "set FindMyMouse.IncludeWinKey `"$($this.IncludeWinKey)`""
        }

        if ($this.ActivationShortcut -notlike '') {
            $Changes.Value += "set FindMyMouse.ActivationShortcut `"$($this.ActivationShortcut)`""
        }

        if ($this.DoNotActivateOnGameMode -notlike '') {
            $Changes.Value += "set FindMyMouse.DoNotActivateOnGameMode `"$($this.DoNotActivateOnGameMode)`""
        }

        if ($this.BackgroundColor -notlike '') {
            $Changes.Value += "set FindMyMouse.BackgroundColor `"$($this.BackgroundColor)`""
        }

        if ($this.SpotlightColor -notlike '') {
            $Changes.Value += "set FindMyMouse.SpotlightColor `"$($this.SpotlightColor)`""
        }

        if ($this.OverlayOpacity -ne $null) {
            $Changes.Value += "set FindMyMouse.OverlayOpacity `"$($this.OverlayOpacity)`""
        }

        if ($this.SpotlightRadius -ne $null) {
            $Changes.Value += "set FindMyMouse.SpotlightRadius `"$($this.SpotlightRadius)`""
        }

        if ($this.AnimationDurationMs -ne $null) {
            $Changes.Value += "set FindMyMouse.AnimationDurationMs `"$($this.AnimationDurationMs)`""
        }

        if ($this.SpotlightInitialZoom -ne $null) {
            $Changes.Value += "set FindMyMouse.SpotlightInitialZoom `"$($this.SpotlightInitialZoom)`""
        }

        if ($this.ExcludedApps -notlike '') {
            $Changes.Value += "set FindMyMouse.ExcludedApps `"$($this.ExcludedApps)`""
        }

        if ($this.ShakingMinimumDistance -ne $null) {
            $Changes.Value += "set FindMyMouse.ShakingMinimumDistance `"$($this.ShakingMinimumDistance)`""
        }

        if ($this.ShakingIntervalMs -ne $null) {
            $Changes.Value += "set FindMyMouse.ShakingIntervalMs `"$($this.ShakingIntervalMs)`""
        }

        if ($this.ShakingFactor -ne $null) {
            $Changes.Value += "set FindMyMouse.ShakingFactor `"$($this.ShakingFactor)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.FindMyMouse `"$($this.Enabled)`""
        }


    }
}
class Hosts {
    [DscProperty()] [Nullable[bool]]
    $ShowStartupWarning = $null

    [DscProperty()] [Nullable[bool]]
    $LaunchAdministrator = $null

    [DscProperty()] [Nullable[bool]]
    $LoopbackDuplicates = $null

    [DscProperty()] [HostsAdditionalLinesPosition]
    $AdditionalLinesPosition 

    [DscProperty()] [HostsEncoding]
    $Encoding 

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ShowStartupWarning -ne $null) {
            $Changes.Value += "set Hosts.ShowStartupWarning `"$($this.ShowStartupWarning)`""
        }

        if ($this.LaunchAdministrator -ne $null) {
            $Changes.Value += "set Hosts.LaunchAdministrator `"$($this.LaunchAdministrator)`""
        }

        if ($this.LoopbackDuplicates -ne $null) {
            $Changes.Value += "set Hosts.LoopbackDuplicates `"$($this.LoopbackDuplicates)`""
        }

        if ($this.AdditionalLinesPosition -ne 0) {
            $Changes.Value += "set Hosts.AdditionalLinesPosition `"$($this.AdditionalLinesPosition)`""
        }

        if ($this.Encoding -ne 0) {
            $Changes.Value += "set Hosts.Encoding `"$($this.Encoding)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.Hosts `"$($this.Enabled)`""
        }


    }
}
class ImageResizer {
    [DscProperty()] [Nullable[int]]
    $ImageresizerSelectedSizeIndex = $null

    [DscProperty()] [string]
    $ImageresizerShrinkOnly = $null

    [DscProperty()] [string]
    $ImageresizerReplace = $null

    [DscProperty()] [string]
    $ImageresizerIgnoreOrientation = $null

    [DscProperty()] [Nullable[int]]
    $ImageresizerJpegQualityLevel = $null

    [DscProperty()] [Nullable[int]]
    $ImageresizerPngInterlaceOption = $null

    [DscProperty()] [Nullable[int]]
    $ImageresizerTiffCompressOption = $null

    [DscProperty()] [string]
    $ImageresizerFileName = $null

    [DscProperty()] [string]
    $ImageresizerKeepDateModified = $null

    [DscProperty()] [string]
    $ImageresizerFallbackEncoder = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null

    [DscProperty()] [Hashtable[]]
    $ImageresizerSizes = @()

    ApplyChanges([ref]$Changes) {
        if ($this.ImageresizerSelectedSizeIndex -ne $null) {
            $Changes.Value += "set ImageResizer.ImageresizerSelectedSizeIndex `"$($this.ImageresizerSelectedSizeIndex)`""
        }

        if ($this.ImageresizerShrinkOnly -notlike '') {
            $Changes.Value += "set ImageResizer.ImageresizerShrinkOnly `"$($this.ImageresizerShrinkOnly)`""
        }

        if ($this.ImageresizerReplace -notlike '') {
            $Changes.Value += "set ImageResizer.ImageresizerReplace `"$($this.ImageresizerReplace)`""
        }

        if ($this.ImageresizerIgnoreOrientation -notlike '') {
            $Changes.Value += "set ImageResizer.ImageresizerIgnoreOrientation `"$($this.ImageresizerIgnoreOrientation)`""
        }

        if ($this.ImageresizerJpegQualityLevel -ne $null) {
            $Changes.Value += "set ImageResizer.ImageresizerJpegQualityLevel `"$($this.ImageresizerJpegQualityLevel)`""
        }

        if ($this.ImageresizerPngInterlaceOption -ne $null) {
            $Changes.Value += "set ImageResizer.ImageresizerPngInterlaceOption `"$($this.ImageresizerPngInterlaceOption)`""
        }

        if ($this.ImageresizerTiffCompressOption -ne $null) {
            $Changes.Value += "set ImageResizer.ImageresizerTiffCompressOption `"$($this.ImageresizerTiffCompressOption)`""
        }

        if ($this.ImageresizerFileName -notlike '') {
            $Changes.Value += "set ImageResizer.ImageresizerFileName `"$($this.ImageresizerFileName)`""
        }

        if ($this.ImageresizerKeepDateModified -notlike '') {
            $Changes.Value += "set ImageResizer.ImageresizerKeepDateModified `"$($this.ImageresizerKeepDateModified)`""
        }

        if ($this.ImageresizerFallbackEncoder -notlike '') {
            $Changes.Value += "set ImageResizer.ImageresizerFallbackEncoder `"$($this.ImageresizerFallbackEncoder)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.ImageResizer `"$($this.Enabled)`""
        }

        if ($this.ImageresizerSizes.Count -gt 0) {
            $AdditionalPropertiesTmpPath = [System.IO.Path]::GetTempFileName()
            $this.ImageresizerSizes | ConvertTo-Json | Set-Content -Path $AdditionalPropertiesTmpPath
            $Changes.Value += "setAdditional ImageResizer `"$AdditionalPropertiesTmpPath`""
        }
    }
}
class KeyboardManager {
    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.KeyboardManager `"$($this.Enabled)`""
        }


    }
}
class MeasureTool {
    [DscProperty()] [string]
    $ActivationShortcut = $null

    [DscProperty()] [Nullable[bool]]
    $ContinuousCapture = $null

    [DscProperty()] [Nullable[bool]]
    $DrawFeetOnCross = $null

    [DscProperty()] [Nullable[bool]]
    $PerColorChannelEdgeDetection = $null

    [DscProperty()] [Nullable[int]]
    $UnitsOfMeasure = $null

    [DscProperty()] [Nullable[int]]
    $PixelTolerance = $null

    [DscProperty()] [string]
    $MeasureCrossColor = $null

    [DscProperty()] [Nullable[int]]
    $DefaultMeasureStyle = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationShortcut -notlike '') {
            $Changes.Value += "set MeasureTool.ActivationShortcut `"$($this.ActivationShortcut)`""
        }

        if ($this.ContinuousCapture -ne $null) {
            $Changes.Value += "set MeasureTool.ContinuousCapture `"$($this.ContinuousCapture)`""
        }

        if ($this.DrawFeetOnCross -ne $null) {
            $Changes.Value += "set MeasureTool.DrawFeetOnCross `"$($this.DrawFeetOnCross)`""
        }

        if ($this.PerColorChannelEdgeDetection -ne $null) {
            $Changes.Value += "set MeasureTool.PerColorChannelEdgeDetection `"$($this.PerColorChannelEdgeDetection)`""
        }

        if ($this.UnitsOfMeasure -ne $null) {
            $Changes.Value += "set MeasureTool.UnitsOfMeasure `"$($this.UnitsOfMeasure)`""
        }

        if ($this.PixelTolerance -ne $null) {
            $Changes.Value += "set MeasureTool.PixelTolerance `"$($this.PixelTolerance)`""
        }

        if ($this.MeasureCrossColor -notlike '') {
            $Changes.Value += "set MeasureTool.MeasureCrossColor `"$($this.MeasureCrossColor)`""
        }

        if ($this.DefaultMeasureStyle -ne $null) {
            $Changes.Value += "set MeasureTool.DefaultMeasureStyle `"$($this.DefaultMeasureStyle)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.MeasureTool `"$($this.Enabled)`""
        }


    }
}
class MouseHighlighter {
    [DscProperty()] [string]
    $ActivationShortcut = $null

    [DscProperty()] [string]
    $LeftButtonClickColor = $null

    [DscProperty()] [string]
    $RightButtonClickColor = $null

    [DscProperty()] [string]
    $AlwaysColor = $null

    [DscProperty()] [Nullable[int]]
    $HighlightRadius = $null

    [DscProperty()] [Nullable[int]]
    $HighlightFadeDelayMs = $null

    [DscProperty()] [Nullable[int]]
    $HighlightFadeDurationMs = $null

    [DscProperty()] [string]
    $AutoActivate = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationShortcut -notlike '') {
            $Changes.Value += "set MouseHighlighter.ActivationShortcut `"$($this.ActivationShortcut)`""
        }

        if ($this.LeftButtonClickColor -notlike '') {
            $Changes.Value += "set MouseHighlighter.LeftButtonClickColor `"$($this.LeftButtonClickColor)`""
        }

        if ($this.RightButtonClickColor -notlike '') {
            $Changes.Value += "set MouseHighlighter.RightButtonClickColor `"$($this.RightButtonClickColor)`""
        }

        if ($this.AlwaysColor -notlike '') {
            $Changes.Value += "set MouseHighlighter.AlwaysColor `"$($this.AlwaysColor)`""
        }

        if ($this.HighlightRadius -ne $null) {
            $Changes.Value += "set MouseHighlighter.HighlightRadius `"$($this.HighlightRadius)`""
        }

        if ($this.HighlightFadeDelayMs -ne $null) {
            $Changes.Value += "set MouseHighlighter.HighlightFadeDelayMs `"$($this.HighlightFadeDelayMs)`""
        }

        if ($this.HighlightFadeDurationMs -ne $null) {
            $Changes.Value += "set MouseHighlighter.HighlightFadeDurationMs `"$($this.HighlightFadeDurationMs)`""
        }

        if ($this.AutoActivate -notlike '') {
            $Changes.Value += "set MouseHighlighter.AutoActivate `"$($this.AutoActivate)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.MouseHighlighter `"$($this.Enabled)`""
        }


    }
}
class MouseJump {
    [DscProperty()] [string]
    $ActivationShortcut = $null

    [DscProperty()] [string]
    $ThumbnailSize = $null

    [DscProperty()] [string]
    $PreviewType = $null

    [DscProperty()] [string]
    $BackgroundColor1 = $null

    [DscProperty()] [string]
    $BackgroundColor2 = $null

    [DscProperty()] [Nullable[int]]
    $BorderThickness = $null

    [DscProperty()] [string]
    $BorderColor = $null

    [DscProperty()] [Nullable[int]]
    $Border3dDepth = $null

    [DscProperty()] [Nullable[int]]
    $BorderPadding = $null

    [DscProperty()] [Nullable[int]]
    $BezelThickness = $null

    [DscProperty()] [string]
    $BezelColor = $null

    [DscProperty()] [Nullable[int]]
    $Bezel3dDepth = $null

    [DscProperty()] [Nullable[int]]
    $ScreenMargin = $null

    [DscProperty()] [string]
    $ScreenColor1 = $null

    [DscProperty()] [string]
    $ScreenColor2 = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationShortcut -notlike '') {
            $Changes.Value += "set MouseJump.ActivationShortcut `"$($this.ActivationShortcut)`""
        }

        if ($this.ThumbnailSize -notlike '') {
            $Changes.Value += "set MouseJump.ThumbnailSize `"$($this.ThumbnailSize)`""
        }

        if ($this.PreviewType -notlike '') {
            $Changes.Value += "set MouseJump.PreviewType `"$($this.PreviewType)`""
        }

        if ($this.BackgroundColor1 -notlike '') {
            $Changes.Value += "set MouseJump.BackgroundColor1 `"$($this.BackgroundColor1)`""
        }

        if ($this.BackgroundColor2 -notlike '') {
            $Changes.Value += "set MouseJump.BackgroundColor2 `"$($this.BackgroundColor2)`""
        }

        if ($this.BorderThickness -ne $null) {
            $Changes.Value += "set MouseJump.BorderThickness `"$($this.BorderThickness)`""
        }

        if ($this.BorderColor -notlike '') {
            $Changes.Value += "set MouseJump.BorderColor `"$($this.BorderColor)`""
        }

        if ($this.Border3dDepth -ne $null) {
            $Changes.Value += "set MouseJump.Border3dDepth `"$($this.Border3dDepth)`""
        }

        if ($this.BorderPadding -ne $null) {
            $Changes.Value += "set MouseJump.BorderPadding `"$($this.BorderPadding)`""
        }

        if ($this.BezelThickness -ne $null) {
            $Changes.Value += "set MouseJump.BezelThickness `"$($this.BezelThickness)`""
        }

        if ($this.BezelColor -notlike '') {
            $Changes.Value += "set MouseJump.BezelColor `"$($this.BezelColor)`""
        }

        if ($this.Bezel3dDepth -ne $null) {
            $Changes.Value += "set MouseJump.Bezel3dDepth `"$($this.Bezel3dDepth)`""
        }

        if ($this.ScreenMargin -ne $null) {
            $Changes.Value += "set MouseJump.ScreenMargin `"$($this.ScreenMargin)`""
        }

        if ($this.ScreenColor1 -notlike '') {
            $Changes.Value += "set MouseJump.ScreenColor1 `"$($this.ScreenColor1)`""
        }

        if ($this.ScreenColor2 -notlike '') {
            $Changes.Value += "set MouseJump.ScreenColor2 `"$($this.ScreenColor2)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.MouseJump `"$($this.Enabled)`""
        }


    }
}
class MousePointerCrosshairs {
    [DscProperty()] [string]
    $ActivationShortcut = $null

    [DscProperty()] [string]
    $CrosshairsColor = $null

    [DscProperty()] [Nullable[int]]
    $CrosshairsOpacity = $null

    [DscProperty()] [Nullable[int]]
    $CrosshairsRadius = $null

    [DscProperty()] [Nullable[int]]
    $CrosshairsThickness = $null

    [DscProperty()] [string]
    $CrosshairsBorderColor = $null

    [DscProperty()] [Nullable[int]]
    $CrosshairsBorderSize = $null

    [DscProperty()] [string]
    $CrosshairsAutoHide = $null

    [DscProperty()] [string]
    $CrosshairsIsFixedLengthEnabled = $null

    [DscProperty()] [Nullable[int]]
    $CrosshairsFixedLength = $null

    [DscProperty()] [string]
    $AutoActivate = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationShortcut -notlike '') {
            $Changes.Value += "set MousePointerCrosshairs.ActivationShortcut `"$($this.ActivationShortcut)`""
        }

        if ($this.CrosshairsColor -notlike '') {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsColor `"$($this.CrosshairsColor)`""
        }

        if ($this.CrosshairsOpacity -ne $null) {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsOpacity `"$($this.CrosshairsOpacity)`""
        }

        if ($this.CrosshairsRadius -ne $null) {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsRadius `"$($this.CrosshairsRadius)`""
        }

        if ($this.CrosshairsThickness -ne $null) {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsThickness `"$($this.CrosshairsThickness)`""
        }

        if ($this.CrosshairsBorderColor -notlike '') {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsBorderColor `"$($this.CrosshairsBorderColor)`""
        }

        if ($this.CrosshairsBorderSize -ne $null) {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsBorderSize `"$($this.CrosshairsBorderSize)`""
        }

        if ($this.CrosshairsAutoHide -notlike '') {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsAutoHide `"$($this.CrosshairsAutoHide)`""
        }

        if ($this.CrosshairsIsFixedLengthEnabled -notlike '') {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsIsFixedLengthEnabled `"$($this.CrosshairsIsFixedLengthEnabled)`""
        }

        if ($this.CrosshairsFixedLength -ne $null) {
            $Changes.Value += "set MousePointerCrosshairs.CrosshairsFixedLength `"$($this.CrosshairsFixedLength)`""
        }

        if ($this.AutoActivate -notlike '') {
            $Changes.Value += "set MousePointerCrosshairs.AutoActivate `"$($this.AutoActivate)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.MousePointerCrosshairs `"$($this.Enabled)`""
        }


    }
}
class MouseWithoutBorders {
    [DscProperty()] [Nullable[bool]]
    $ShowOriginalUI = $null

    [DscProperty()] [Nullable[bool]]
    $WrapMouse = $null

    [DscProperty()] [Nullable[bool]]
    $ShareClipboard = $null

    [DscProperty()] [Nullable[bool]]
    $TransferFile = $null

    [DscProperty()] [Nullable[bool]]
    $HideMouseAtScreenEdge = $null

    [DscProperty()] [Nullable[bool]]
    $DrawMouseCursor = $null

    [DscProperty()] [Nullable[bool]]
    $ValidateRemoteMachineIP = $null

    [DscProperty()] [Nullable[bool]]
    $SameSubnetOnly = $null

    [DscProperty()] [Nullable[bool]]
    $BlockScreenSaverOnOtherMachines = $null

    [DscProperty()] [Nullable[bool]]
    $MoveMouseRelatively = $null

    [DscProperty()] [Nullable[bool]]
    $BlockMouseAtScreenCorners = $null

    [DscProperty()] [Nullable[bool]]
    $ShowClipboardAndNetworkStatusMessages = $null

    [DscProperty()] [Nullable[int]]
    $EasyMouse = $null

    [DscProperty()] [Nullable[int]]
    $HotKeySwitchMachine = $null

    [DscProperty()] [string]
    $ToggleEasyMouseShortcut = $null

    [DscProperty()] [string]
    $LockMachineShortcut = $null

    [DscProperty()] [string]
    $ReconnectShortcut = $null

    [DscProperty()] [string]
    $Switch2AllPCShortcut = $null

    [DscProperty()] [Nullable[bool]]
    $DrawMouseEx = $null

    [DscProperty()] [string]
    $Name2IP = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ShowOriginalUI -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.ShowOriginalUI `"$($this.ShowOriginalUI)`""
        }

        if ($this.WrapMouse -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.WrapMouse `"$($this.WrapMouse)`""
        }

        if ($this.ShareClipboard -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.ShareClipboard `"$($this.ShareClipboard)`""
        }

        if ($this.TransferFile -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.TransferFile `"$($this.TransferFile)`""
        }

        if ($this.HideMouseAtScreenEdge -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.HideMouseAtScreenEdge `"$($this.HideMouseAtScreenEdge)`""
        }

        if ($this.DrawMouseCursor -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.DrawMouseCursor `"$($this.DrawMouseCursor)`""
        }

        if ($this.ValidateRemoteMachineIP -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.ValidateRemoteMachineIP `"$($this.ValidateRemoteMachineIP)`""
        }

        if ($this.SameSubnetOnly -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.SameSubnetOnly `"$($this.SameSubnetOnly)`""
        }

        if ($this.BlockScreenSaverOnOtherMachines -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.BlockScreenSaverOnOtherMachines `"$($this.BlockScreenSaverOnOtherMachines)`""
        }

        if ($this.MoveMouseRelatively -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.MoveMouseRelatively `"$($this.MoveMouseRelatively)`""
        }

        if ($this.BlockMouseAtScreenCorners -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.BlockMouseAtScreenCorners `"$($this.BlockMouseAtScreenCorners)`""
        }

        if ($this.ShowClipboardAndNetworkStatusMessages -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.ShowClipboardAndNetworkStatusMessages `"$($this.ShowClipboardAndNetworkStatusMessages)`""
        }

        if ($this.EasyMouse -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.EasyMouse `"$($this.EasyMouse)`""
        }

        if ($this.HotKeySwitchMachine -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.HotKeySwitchMachine `"$($this.HotKeySwitchMachine)`""
        }

        if ($this.ToggleEasyMouseShortcut -notlike '') {
            $Changes.Value += "set MouseWithoutBorders.ToggleEasyMouseShortcut `"$($this.ToggleEasyMouseShortcut)`""
        }

        if ($this.LockMachineShortcut -notlike '') {
            $Changes.Value += "set MouseWithoutBorders.LockMachineShortcut `"$($this.LockMachineShortcut)`""
        }

        if ($this.ReconnectShortcut -notlike '') {
            $Changes.Value += "set MouseWithoutBorders.ReconnectShortcut `"$($this.ReconnectShortcut)`""
        }

        if ($this.Switch2AllPCShortcut -notlike '') {
            $Changes.Value += "set MouseWithoutBorders.Switch2AllPCShortcut `"$($this.Switch2AllPCShortcut)`""
        }

        if ($this.DrawMouseEx -ne $null) {
            $Changes.Value += "set MouseWithoutBorders.DrawMouseEx `"$($this.DrawMouseEx)`""
        }

        if ($this.Name2IP -notlike '') {
            $Changes.Value += "set MouseWithoutBorders.Name2IP `"$($this.Name2IP)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.MouseWithoutBorders `"$($this.Enabled)`""
        }


    }
}
class NewPlus {
    [DscProperty()] [string]
    $HideFileExtension = $null

    [DscProperty()] [string]
    $HideStartingDigits = $null

    [DscProperty()] [string]
    $TemplateLocation = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.HideFileExtension -notlike '') {
            $Changes.Value += "set NewPlus.HideFileExtension `"$($this.HideFileExtension)`""
        }

        if ($this.HideStartingDigits -notlike '') {
            $Changes.Value += "set NewPlus.HideStartingDigits `"$($this.HideStartingDigits)`""
        }

        if ($this.TemplateLocation -notlike '') {
            $Changes.Value += "set NewPlus.TemplateLocation `"$($this.TemplateLocation)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.NewPlus `"$($this.Enabled)`""
        }


    }
}
class Peek {
    [DscProperty()] [string]
    $ActivationShortcut = $null

    [DscProperty()] [string]
    $AlwaysRunNotElevated = $null

    [DscProperty()] [string]
    $CloseAfterLosingFocus = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationShortcut -notlike '') {
            $Changes.Value += "set Peek.ActivationShortcut `"$($this.ActivationShortcut)`""
        }

        if ($this.AlwaysRunNotElevated -notlike '') {
            $Changes.Value += "set Peek.AlwaysRunNotElevated `"$($this.AlwaysRunNotElevated)`""
        }

        if ($this.CloseAfterLosingFocus -notlike '') {
            $Changes.Value += "set Peek.CloseAfterLosingFocus `"$($this.CloseAfterLosingFocus)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.Peek `"$($this.Enabled)`""
        }


    }
}
class PowerAccent {
    [DscProperty()] [PowerAccentActivationKey]
    $ActivationKey 

    [DscProperty()] [Nullable[bool]]
    $DoNotActivateOnGameMode = $null

    [DscProperty()] [string]
    $ToolbarPosition = $null

    [DscProperty()] [Nullable[int]]
    $InputTime = $null

    [DscProperty()] [string]
    $SelectedLang = $null

    [DscProperty()] [string]
    $ExcludedApps = $null

    [DscProperty()] [Nullable[bool]]
    $ShowUnicodeDescription = $null

    [DscProperty()] [Nullable[bool]]
    $SortByUsageFrequency = $null

    [DscProperty()] [Nullable[bool]]
    $StartSelectionFromTheLeft = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationKey -ne 0) {
            $Changes.Value += "set PowerAccent.ActivationKey `"$($this.ActivationKey)`""
        }

        if ($this.DoNotActivateOnGameMode -ne $null) {
            $Changes.Value += "set PowerAccent.DoNotActivateOnGameMode `"$($this.DoNotActivateOnGameMode)`""
        }

        if ($this.ToolbarPosition -notlike '') {
            $Changes.Value += "set PowerAccent.ToolbarPosition `"$($this.ToolbarPosition)`""
        }

        if ($this.InputTime -ne $null) {
            $Changes.Value += "set PowerAccent.InputTime `"$($this.InputTime)`""
        }

        if ($this.SelectedLang -notlike '') {
            $Changes.Value += "set PowerAccent.SelectedLang `"$($this.SelectedLang)`""
        }

        if ($this.ExcludedApps -notlike '') {
            $Changes.Value += "set PowerAccent.ExcludedApps `"$($this.ExcludedApps)`""
        }

        if ($this.ShowUnicodeDescription -ne $null) {
            $Changes.Value += "set PowerAccent.ShowUnicodeDescription `"$($this.ShowUnicodeDescription)`""
        }

        if ($this.SortByUsageFrequency -ne $null) {
            $Changes.Value += "set PowerAccent.SortByUsageFrequency `"$($this.SortByUsageFrequency)`""
        }

        if ($this.StartSelectionFromTheLeft -ne $null) {
            $Changes.Value += "set PowerAccent.StartSelectionFromTheLeft `"$($this.StartSelectionFromTheLeft)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.PowerAccent `"$($this.Enabled)`""
        }


    }
}
class PowerLauncher {
    [DscProperty()] [Nullable[int]]
    $MaximumNumberOfResults = $null

    [DscProperty()] [string]
    $OpenPowerLauncher = $null

    [DscProperty()] [Nullable[bool]]
    $IgnoreHotkeysInFullscreen = $null

    [DscProperty()] [Nullable[bool]]
    $ClearInputOnLaunch = $null

    [DscProperty()] [Nullable[bool]]
    $TabSelectsContextButtons = $null

    [DscProperty()] [Theme]
    $Theme 

    [DscProperty()] [Nullable[int]]
    $TitleFontSize = $null

    [DscProperty()] [StartupPosition]
    $Position 

    [DscProperty()] [Nullable[bool]]
    $UseCentralizedKeyboardHook = $null

    [DscProperty()] [Nullable[bool]]
    $SearchQueryResultsWithDelay = $null

    [DscProperty()] [Nullable[int]]
    $SearchInputDelay = $null

    [DscProperty()] [Nullable[int]]
    $SearchInputDelayFast = $null

    [DscProperty()] [Nullable[int]]
    $SearchClickedItemWeight = $null

    [DscProperty()] [Nullable[bool]]
    $SearchQueryTuningEnabled = $null

    [DscProperty()] [Nullable[bool]]
    $SearchWaitForSlowResults = $null

    [DscProperty()] [Nullable[bool]]
    $UsePinyin = $null

    [DscProperty()] [Nullable[bool]]
    $GenerateThumbnailsFromFiles = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null

    [DscProperty()] [Hashtable[]]
    $Plugins = @()

    ApplyChanges([ref]$Changes) {
        if ($this.MaximumNumberOfResults -ne $null) {
            $Changes.Value += "set PowerLauncher.MaximumNumberOfResults `"$($this.MaximumNumberOfResults)`""
        }

        if ($this.OpenPowerLauncher -notlike '') {
            $Changes.Value += "set PowerLauncher.OpenPowerLauncher `"$($this.OpenPowerLauncher)`""
        }

        if ($this.IgnoreHotkeysInFullscreen -ne $null) {
            $Changes.Value += "set PowerLauncher.IgnoreHotkeysInFullscreen `"$($this.IgnoreHotkeysInFullscreen)`""
        }

        if ($this.ClearInputOnLaunch -ne $null) {
            $Changes.Value += "set PowerLauncher.ClearInputOnLaunch `"$($this.ClearInputOnLaunch)`""
        }

        if ($this.TabSelectsContextButtons -ne $null) {
            $Changes.Value += "set PowerLauncher.TabSelectsContextButtons `"$($this.TabSelectsContextButtons)`""
        }

        if ($this.Theme -ne 0) {
            $Changes.Value += "set PowerLauncher.Theme `"$($this.Theme)`""
        }

        if ($this.TitleFontSize -ne $null) {
            $Changes.Value += "set PowerLauncher.TitleFontSize `"$($this.TitleFontSize)`""
        }

        if ($this.Position -ne 0) {
            $Changes.Value += "set PowerLauncher.Position `"$($this.Position)`""
        }

        if ($this.UseCentralizedKeyboardHook -ne $null) {
            $Changes.Value += "set PowerLauncher.UseCentralizedKeyboardHook `"$($this.UseCentralizedKeyboardHook)`""
        }

        if ($this.SearchQueryResultsWithDelay -ne $null) {
            $Changes.Value += "set PowerLauncher.SearchQueryResultsWithDelay `"$($this.SearchQueryResultsWithDelay)`""
        }

        if ($this.SearchInputDelay -ne $null) {
            $Changes.Value += "set PowerLauncher.SearchInputDelay `"$($this.SearchInputDelay)`""
        }

        if ($this.SearchInputDelayFast -ne $null) {
            $Changes.Value += "set PowerLauncher.SearchInputDelayFast `"$($this.SearchInputDelayFast)`""
        }

        if ($this.SearchClickedItemWeight -ne $null) {
            $Changes.Value += "set PowerLauncher.SearchClickedItemWeight `"$($this.SearchClickedItemWeight)`""
        }

        if ($this.SearchQueryTuningEnabled -ne $null) {
            $Changes.Value += "set PowerLauncher.SearchQueryTuningEnabled `"$($this.SearchQueryTuningEnabled)`""
        }

        if ($this.SearchWaitForSlowResults -ne $null) {
            $Changes.Value += "set PowerLauncher.SearchWaitForSlowResults `"$($this.SearchWaitForSlowResults)`""
        }

        if ($this.UsePinyin -ne $null) {
            $Changes.Value += "set PowerLauncher.UsePinyin `"$($this.UsePinyin)`""
        }

        if ($this.GenerateThumbnailsFromFiles -ne $null) {
            $Changes.Value += "set PowerLauncher.GenerateThumbnailsFromFiles `"$($this.GenerateThumbnailsFromFiles)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.PowerLauncher `"$($this.Enabled)`""
        }

        if ($this.Plugins.Count -gt 0) {
            $AdditionalPropertiesTmpPath = [System.IO.Path]::GetTempFileName()
            $this.Plugins | ConvertTo-Json | Set-Content -Path $AdditionalPropertiesTmpPath
            $Changes.Value += "setAdditional PowerLauncher `"$AdditionalPropertiesTmpPath`""
        }
    }
}
class PowerOcr {
    [DscProperty()] [string]
    $ActivationShortcut = $null

    [DscProperty()] [string]
    $PreferredLanguage = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ActivationShortcut -notlike '') {
            $Changes.Value += "set PowerOcr.ActivationShortcut `"$($this.ActivationShortcut)`""
        }

        if ($this.PreferredLanguage -notlike '') {
            $Changes.Value += "set PowerOcr.PreferredLanguage `"$($this.PreferredLanguage)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.PowerOcr `"$($this.Enabled)`""
        }


    }
}
class PowerPreview {
    [DscProperty()] [Nullable[bool]]
    $EnableSvgPreview = $null

    [DscProperty()] [Nullable[int]]
    $SvgBackgroundColorMode = $null

    [DscProperty()] [string]
    $SvgBackgroundSolidColor = $null

    [DscProperty()] [Nullable[int]]
    $SvgBackgroundCheckeredShade = $null

    [DscProperty()] [Nullable[bool]]
    $EnableSvgThumbnail = $null

    [DscProperty()] [Nullable[bool]]
    $EnableMdPreview = $null

    [DscProperty()] [Nullable[bool]]
    $EnableMonacoPreview = $null

    [DscProperty()] [Nullable[bool]]
    $EnableMonacoPreviewWordWrap = $null

    [DscProperty()] [Nullable[bool]]
    $MonacoPreviewTryFormat = $null

    [DscProperty()] [Nullable[int]]
    $MonacoPreviewMaxFileSize = $null

    [DscProperty()] [Nullable[int]]
    $MonacoPreviewFontSize = $null

    [DscProperty()] [Nullable[bool]]
    $MonacoPreviewStickyScroll = $null

    [DscProperty()] [Nullable[bool]]
    $MonacoPreviewMinimap = $null

    [DscProperty()] [Nullable[bool]]
    $EnablePdfPreview = $null

    [DscProperty()] [Nullable[bool]]
    $EnablePdfThumbnail = $null

    [DscProperty()] [Nullable[bool]]
    $EnableGcodePreview = $null

    [DscProperty()] [Nullable[bool]]
    $EnableGcodeThumbnail = $null

    [DscProperty()] [Nullable[bool]]
    $EnableStlThumbnail = $null

    [DscProperty()] [string]
    $StlThumbnailColor = $null

    [DscProperty()] [Nullable[bool]]
    $EnableQoiPreview = $null

    [DscProperty()] [Nullable[bool]]
    $EnableQoiThumbnail = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.EnableSvgPreview -ne $null) {
            $Changes.Value += "set PowerPreview.EnableSvgPreview `"$($this.EnableSvgPreview)`""
        }

        if ($this.SvgBackgroundColorMode -ne $null) {
            $Changes.Value += "set PowerPreview.SvgBackgroundColorMode `"$($this.SvgBackgroundColorMode)`""
        }

        if ($this.SvgBackgroundSolidColor -notlike '') {
            $Changes.Value += "set PowerPreview.SvgBackgroundSolidColor `"$($this.SvgBackgroundSolidColor)`""
        }

        if ($this.SvgBackgroundCheckeredShade -ne $null) {
            $Changes.Value += "set PowerPreview.SvgBackgroundCheckeredShade `"$($this.SvgBackgroundCheckeredShade)`""
        }

        if ($this.EnableSvgThumbnail -ne $null) {
            $Changes.Value += "set PowerPreview.EnableSvgThumbnail `"$($this.EnableSvgThumbnail)`""
        }

        if ($this.EnableMdPreview -ne $null) {
            $Changes.Value += "set PowerPreview.EnableMdPreview `"$($this.EnableMdPreview)`""
        }

        if ($this.EnableMonacoPreview -ne $null) {
            $Changes.Value += "set PowerPreview.EnableMonacoPreview `"$($this.EnableMonacoPreview)`""
        }

        if ($this.EnableMonacoPreviewWordWrap -ne $null) {
            $Changes.Value += "set PowerPreview.EnableMonacoPreviewWordWrap `"$($this.EnableMonacoPreviewWordWrap)`""
        }

        if ($this.MonacoPreviewTryFormat -ne $null) {
            $Changes.Value += "set PowerPreview.MonacoPreviewTryFormat `"$($this.MonacoPreviewTryFormat)`""
        }

        if ($this.MonacoPreviewMaxFileSize -ne $null) {
            $Changes.Value += "set PowerPreview.MonacoPreviewMaxFileSize `"$($this.MonacoPreviewMaxFileSize)`""
        }

        if ($this.MonacoPreviewFontSize -ne $null) {
            $Changes.Value += "set PowerPreview.MonacoPreviewFontSize `"$($this.MonacoPreviewFontSize)`""
        }

        if ($this.MonacoPreviewStickyScroll -ne $null) {
            $Changes.Value += "set PowerPreview.MonacoPreviewStickyScroll `"$($this.MonacoPreviewStickyScroll)`""
        }

        if ($this.MonacoPreviewMinimap -ne $null) {
            $Changes.Value += "set PowerPreview.MonacoPreviewMinimap `"$($this.MonacoPreviewMinimap)`""
        }

        if ($this.EnablePdfPreview -ne $null) {
            $Changes.Value += "set PowerPreview.EnablePdfPreview `"$($this.EnablePdfPreview)`""
        }

        if ($this.EnablePdfThumbnail -ne $null) {
            $Changes.Value += "set PowerPreview.EnablePdfThumbnail `"$($this.EnablePdfThumbnail)`""
        }

        if ($this.EnableGcodePreview -ne $null) {
            $Changes.Value += "set PowerPreview.EnableGcodePreview `"$($this.EnableGcodePreview)`""
        }

        if ($this.EnableGcodeThumbnail -ne $null) {
            $Changes.Value += "set PowerPreview.EnableGcodeThumbnail `"$($this.EnableGcodeThumbnail)`""
        }

        if ($this.EnableStlThumbnail -ne $null) {
            $Changes.Value += "set PowerPreview.EnableStlThumbnail `"$($this.EnableStlThumbnail)`""
        }

        if ($this.StlThumbnailColor -notlike '') {
            $Changes.Value += "set PowerPreview.StlThumbnailColor `"$($this.StlThumbnailColor)`""
        }

        if ($this.EnableQoiPreview -ne $null) {
            $Changes.Value += "set PowerPreview.EnableQoiPreview `"$($this.EnableQoiPreview)`""
        }

        if ($this.EnableQoiThumbnail -ne $null) {
            $Changes.Value += "set PowerPreview.EnableQoiThumbnail `"$($this.EnableQoiThumbnail)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.PowerPreview `"$($this.Enabled)`""
        }


    }
}
class PowerRename {
    [DscProperty()] [string]
    $MRUEnabled = $null

    [DscProperty()] [Nullable[int]]
    $MaxMRUSize = $null

    [DscProperty()] [string]
    $ExtendedContextMenuOnly = $null

    [DscProperty()] [string]
    $UseBoostLib = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.MRUEnabled -notlike '') {
            $Changes.Value += "set PowerRename.MRUEnabled `"$($this.MRUEnabled)`""
        }

        if ($this.MaxMRUSize -ne $null) {
            $Changes.Value += "set PowerRename.MaxMRUSize `"$($this.MaxMRUSize)`""
        }

        if ($this.ExtendedContextMenuOnly -notlike '') {
            $Changes.Value += "set PowerRename.ExtendedContextMenuOnly `"$($this.ExtendedContextMenuOnly)`""
        }

        if ($this.UseBoostLib -notlike '') {
            $Changes.Value += "set PowerRename.UseBoostLib `"$($this.UseBoostLib)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.PowerRename `"$($this.Enabled)`""
        }


    }
}
class RegistryPreview {
    [DscProperty()] [Nullable[bool]]
    $DefaultRegApp = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.DefaultRegApp -ne $null) {
            $Changes.Value += "set RegistryPreview.DefaultRegApp `"$($this.DefaultRegApp)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.RegistryPreview `"$($this.Enabled)`""
        }


    }
}
class ShortcutGuide {
    [DscProperty()] [string]
    $OpenShortcutGuide = $null

    [DscProperty()] [Nullable[int]]
    $OverlayOpacity = $null

    [DscProperty()] [string]
    $UseLegacyPressWinKeyBehavior = $null

    [DscProperty()] [Nullable[int]]
    $PressTimeForGlobalWindowsShortcuts = $null

    [DscProperty()] [Nullable[int]]
    $PressTimeForTaskbarIconShortcuts = $null

    [DscProperty()] [string]
    $Theme = $null

    [DscProperty()] [string]
    $DisabledApps = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.OpenShortcutGuide -notlike '') {
            $Changes.Value += "set ShortcutGuide.OpenShortcutGuide `"$($this.OpenShortcutGuide)`""
        }

        if ($this.OverlayOpacity -ne $null) {
            $Changes.Value += "set ShortcutGuide.OverlayOpacity `"$($this.OverlayOpacity)`""
        }

        if ($this.UseLegacyPressWinKeyBehavior -notlike '') {
            $Changes.Value += "set ShortcutGuide.UseLegacyPressWinKeyBehavior `"$($this.UseLegacyPressWinKeyBehavior)`""
        }

        if ($this.PressTimeForGlobalWindowsShortcuts -ne $null) {
            $Changes.Value += "set ShortcutGuide.PressTimeForGlobalWindowsShortcuts `"$($this.PressTimeForGlobalWindowsShortcuts)`""
        }

        if ($this.PressTimeForTaskbarIconShortcuts -ne $null) {
            $Changes.Value += "set ShortcutGuide.PressTimeForTaskbarIconShortcuts `"$($this.PressTimeForTaskbarIconShortcuts)`""
        }

        if ($this.Theme -notlike '') {
            $Changes.Value += "set ShortcutGuide.Theme `"$($this.Theme)`""
        }

        if ($this.DisabledApps -notlike '') {
            $Changes.Value += "set ShortcutGuide.DisabledApps `"$($this.DisabledApps)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.ShortcutGuide `"$($this.Enabled)`""
        }


    }
}
class Workspaces {
    [DscProperty()] [string]
    $Hotkey = $null

    [DscProperty()] [SortByProperty]
    $SortBy 

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.Hotkey -notlike '') {
            $Changes.Value += "set Workspaces.Hotkey `"$($this.Hotkey)`""
        }

        if ($this.SortBy -ne 0) {
            $Changes.Value += "set Workspaces.SortBy `"$($this.SortBy)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.Workspaces `"$($this.Enabled)`""
        }


    }
}
class ZoomIt {
    [DscProperty()] [string]
    $ToggleKey = $null

    [DscProperty()] [string]
    $LiveZoomToggleKey = $null

    [DscProperty()] [string]
    $DrawToggleKey = $null

    [DscProperty()] [string]
    $RecordToggleKey = $null

    [DscProperty()] [string]
    $SnipToggleKey = $null

    [DscProperty()] [string]
    $BreakTimerKey = $null

    [DscProperty()] [string]
    $Font = $null

    [DscProperty()] [string]
    $DemoTypeToggleKey = $null

    [DscProperty()] [string]
    $DemoTypeFile = $null

    [DscProperty()] [Nullable[int]]
    $DemoTypeSpeedSlider = $null

    [DscProperty()] [string]
    $DemoTypeUserDrivenMode = $null

    [DscProperty()] [Nullable[int]]
    $BreakTimeout = $null

    [DscProperty()] [Nullable[int]]
    $BreakOpacity = $null

    [DscProperty()] [string]
    $BreakPlaySoundFile = $null

    [DscProperty()] [string]
    $BreakSoundFile = $null

    [DscProperty()] [string]
    $BreakShowBackgroundFile = $null

    [DscProperty()] [string]
    $BreakBackgroundStretch = $null

    [DscProperty()] [string]
    $BreakBackgroundFile = $null

    [DscProperty()] [Nullable[int]]
    $BreakTimerPosition = $null

    [DscProperty()] [string]
    $BreakShowDesktop = $null

    [DscProperty()] [string]
    $ShowExpiredTime = $null

    [DscProperty()] [string]
    $ShowTrayIcon = $null

    [DscProperty()] [string]
    $AnimnateZoom = $null

    [DscProperty()] [Nullable[int]]
    $ZoominSliderLevel = $null

    [DscProperty()] [Nullable[int]]
    $RecordScaling = $null

    [DscProperty()] [string]
    $CaptureAudio = $null

    [DscProperty()] [string]
    $MicrophoneDeviceId = $null

    [DscProperty(Key)] [Nullable[bool]]
    $Enabled = $null
    ApplyChanges([ref]$Changes) {
        if ($this.ToggleKey -notlike '') {
            $Changes.Value += "set ZoomIt.ToggleKey `"$($this.ToggleKey)`""
        }

        if ($this.LiveZoomToggleKey -notlike '') {
            $Changes.Value += "set ZoomIt.LiveZoomToggleKey `"$($this.LiveZoomToggleKey)`""
        }

        if ($this.DrawToggleKey -notlike '') {
            $Changes.Value += "set ZoomIt.DrawToggleKey `"$($this.DrawToggleKey)`""
        }

        if ($this.RecordToggleKey -notlike '') {
            $Changes.Value += "set ZoomIt.RecordToggleKey `"$($this.RecordToggleKey)`""
        }

        if ($this.SnipToggleKey -notlike '') {
            $Changes.Value += "set ZoomIt.SnipToggleKey `"$($this.SnipToggleKey)`""
        }

        if ($this.BreakTimerKey -notlike '') {
            $Changes.Value += "set ZoomIt.BreakTimerKey `"$($this.BreakTimerKey)`""
        }

        if ($this.Font -notlike '') {
            $Changes.Value += "set ZoomIt.Font `"$($this.Font)`""
        }

        if ($this.DemoTypeToggleKey -notlike '') {
            $Changes.Value += "set ZoomIt.DemoTypeToggleKey `"$($this.DemoTypeToggleKey)`""
        }

        if ($this.DemoTypeFile -notlike '') {
            $Changes.Value += "set ZoomIt.DemoTypeFile `"$($this.DemoTypeFile)`""
        }

        if ($this.DemoTypeSpeedSlider -ne $null) {
            $Changes.Value += "set ZoomIt.DemoTypeSpeedSlider `"$($this.DemoTypeSpeedSlider)`""
        }

        if ($this.DemoTypeUserDrivenMode -notlike '') {
            $Changes.Value += "set ZoomIt.DemoTypeUserDrivenMode `"$($this.DemoTypeUserDrivenMode)`""
        }

        if ($this.BreakTimeout -ne $null) {
            $Changes.Value += "set ZoomIt.BreakTimeout `"$($this.BreakTimeout)`""
        }

        if ($this.BreakOpacity -ne $null) {
            $Changes.Value += "set ZoomIt.BreakOpacity `"$($this.BreakOpacity)`""
        }

        if ($this.BreakPlaySoundFile -notlike '') {
            $Changes.Value += "set ZoomIt.BreakPlaySoundFile `"$($this.BreakPlaySoundFile)`""
        }

        if ($this.BreakSoundFile -notlike '') {
            $Changes.Value += "set ZoomIt.BreakSoundFile `"$($this.BreakSoundFile)`""
        }

        if ($this.BreakShowBackgroundFile -notlike '') {
            $Changes.Value += "set ZoomIt.BreakShowBackgroundFile `"$($this.BreakShowBackgroundFile)`""
        }

        if ($this.BreakBackgroundStretch -notlike '') {
            $Changes.Value += "set ZoomIt.BreakBackgroundStretch `"$($this.BreakBackgroundStretch)`""
        }

        if ($this.BreakBackgroundFile -notlike '') {
            $Changes.Value += "set ZoomIt.BreakBackgroundFile `"$($this.BreakBackgroundFile)`""
        }

        if ($this.BreakTimerPosition -ne $null) {
            $Changes.Value += "set ZoomIt.BreakTimerPosition `"$($this.BreakTimerPosition)`""
        }

        if ($this.BreakShowDesktop -notlike '') {
            $Changes.Value += "set ZoomIt.BreakShowDesktop `"$($this.BreakShowDesktop)`""
        }

        if ($this.ShowExpiredTime -notlike '') {
            $Changes.Value += "set ZoomIt.ShowExpiredTime `"$($this.ShowExpiredTime)`""
        }

        if ($this.ShowTrayIcon -notlike '') {
            $Changes.Value += "set ZoomIt.ShowTrayIcon `"$($this.ShowTrayIcon)`""
        }

        if ($this.AnimnateZoom -notlike '') {
            $Changes.Value += "set ZoomIt.AnimnateZoom `"$($this.AnimnateZoom)`""
        }

        if ($this.ZoominSliderLevel -ne $null) {
            $Changes.Value += "set ZoomIt.ZoominSliderLevel `"$($this.ZoominSliderLevel)`""
        }

        if ($this.RecordScaling -ne $null) {
            $Changes.Value += "set ZoomIt.RecordScaling `"$($this.RecordScaling)`""
        }

        if ($this.CaptureAudio -notlike '') {
            $Changes.Value += "set ZoomIt.CaptureAudio `"$($this.CaptureAudio)`""
        }

        if ($this.MicrophoneDeviceId -notlike '') {
            $Changes.Value += "set ZoomIt.MicrophoneDeviceId `"$($this.MicrophoneDeviceId)`""
        }

        if ($this.Enabled -ne $null) {
            $Changes.Value += "set General.Enabled.ZoomIt `"$($this.Enabled)`""
        }


    }
}
class GeneralSettings {
    [DscProperty()] [Nullable[bool]]
    $Startup = $null

    [DscProperty()] [Nullable[bool]]
    $EnableWarningsElevatedApps = $null

    [DscProperty()] [string]
    $Theme = $null

    [DscProperty()] [Nullable[bool]]
    $ShowNewUpdatesToastNotification = $null

    [DscProperty()] [Nullable[bool]]
    $AutoDownloadUpdates = $null

    [DscProperty()] [Nullable[bool]]
    $ShowWhatsNewAfterUpdates = $null

    [DscProperty()] [Nullable[bool]]
    $EnableExperimentation = $null

    ApplyChanges([ref]$Changes) {
        if ($this.Startup -ne $null) {
            $Changes.Value += "set GeneralSettings.Startup `"$($this.Startup)`""
        }

        if ($this.EnableWarningsElevatedApps -ne $null) {
            $Changes.Value += "set GeneralSettings.EnableWarningsElevatedApps `"$($this.EnableWarningsElevatedApps)`""
        }

        if ($this.Theme -notlike '') {
            $Changes.Value += "set GeneralSettings.Theme `"$($this.Theme)`""
        }

        if ($this.ShowNewUpdatesToastNotification -ne $null) {
            $Changes.Value += "set GeneralSettings.ShowNewUpdatesToastNotification `"$($this.ShowNewUpdatesToastNotification)`""
        }

        if ($this.AutoDownloadUpdates -ne $null) {
            $Changes.Value += "set GeneralSettings.AutoDownloadUpdates `"$($this.AutoDownloadUpdates)`""
        }

        if ($this.ShowWhatsNewAfterUpdates -ne $null) {
            $Changes.Value += "set GeneralSettings.ShowWhatsNewAfterUpdates `"$($this.ShowWhatsNewAfterUpdates)`""
        }

        if ($this.EnableExperimentation -ne $null) {
            $Changes.Value += "set GeneralSettings.EnableExperimentation `"$($this.EnableExperimentation)`""
        }




    }
}

[DscResource()]
class PowerToysConfigure {
    [DscProperty(Key)] [PowerToysConfigureEnsure]
    $Ensure = [PowerToysConfigureEnsure]::Present

    [bool] $Debug = $false

    [DscProperty()]
    [AdvancedPaste]$AdvancedPaste = [AdvancedPaste]::new()

    [DscProperty()]
    [AlwaysOnTop]$AlwaysOnTop = [AlwaysOnTop]::new()

    [DscProperty()]
    [Awake]$Awake = [Awake]::new()

    [DscProperty()]
    [ColorPicker]$ColorPicker = [ColorPicker]::new()

    [DscProperty()]
    [CropAndLock]$CropAndLock = [CropAndLock]::new()

    [DscProperty()]
    [EnvironmentVariables]$EnvironmentVariables = [EnvironmentVariables]::new()

    [DscProperty()]
    [FancyZones]$FancyZones = [FancyZones]::new()

    [DscProperty()]
    [FileLocksmith]$FileLocksmith = [FileLocksmith]::new()

    [DscProperty()]
    [FindMyMouse]$FindMyMouse = [FindMyMouse]::new()

    [DscProperty()]
    [Hosts]$Hosts = [Hosts]::new()

    [DscProperty()]
    [ImageResizer]$ImageResizer = [ImageResizer]::new()

    [DscProperty()]
    [KeyboardManager]$KeyboardManager = [KeyboardManager]::new()

    [DscProperty()]
    [MeasureTool]$MeasureTool = [MeasureTool]::new()

    [DscProperty()]
    [MouseHighlighter]$MouseHighlighter = [MouseHighlighter]::new()

    [DscProperty()]
    [MouseJump]$MouseJump = [MouseJump]::new()

    [DscProperty()]
    [MousePointerCrosshairs]$MousePointerCrosshairs = [MousePointerCrosshairs]::new()

    [DscProperty()]
    [MouseWithoutBorders]$MouseWithoutBorders = [MouseWithoutBorders]::new()

    [DscProperty()]
    [NewPlus]$NewPlus = [NewPlus]::new()

    [DscProperty()]
    [Peek]$Peek = [Peek]::new()

    [DscProperty()]
    [PowerAccent]$PowerAccent = [PowerAccent]::new()

    [DscProperty()]
    [PowerLauncher]$PowerLauncher = [PowerLauncher]::new()

    [DscProperty()]
    [PowerOcr]$PowerOcr = [PowerOcr]::new()

    [DscProperty()]
    [PowerPreview]$PowerPreview = [PowerPreview]::new()

    [DscProperty()]
    [PowerRename]$PowerRename = [PowerRename]::new()

    [DscProperty()]
    [RegistryPreview]$RegistryPreview = [RegistryPreview]::new()

    [DscProperty()]
    [ShortcutGuide]$ShortcutGuide = [ShortcutGuide]::new()

    [DscProperty()]
    [Workspaces]$Workspaces = [Workspaces]::new()

    [DscProperty()]
    [ZoomIt]$ZoomIt = [ZoomIt]::new()

    [DscProperty()]
    [GeneralSettings]$GeneralSettings = [GeneralSettings]::new()


    [string] GetPowerToysSettingsPath() {
        $installation = Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | ForEach-Object { Get-ItemProperty $_.PsPath } | Where-Object { $_.DisplayName -eq "PowerToys (Preview)" -and $_.DisplayVersion -eq "0.89.0" }

        if (-not $installation)
        {
            $installation = Get-ChildItem HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | ForEach-Object { Get-ItemProperty $_.PsPath } | Where-Object { $_.DisplayName -eq "PowerToys (Preview)" -and $_.DisplayVersion -eq "0.89.0" }
        }

        if ($installation) {
            $SettingsExePath = Join-Path (Join-Path $installation.InstallLocation WinUI3Apps) PowerToys.Settings.exe
            $SettingsExePath = "`"$SettingsExePath`""
        } else {
            throw "PowerToys installation wasn't found."
        }

        return $SettingsExePath
    }

    [PowerToysConfigure] Get() {
        $CurrentState = [PowerToysConfigure]::new()
        $SettingsExePath = $this.GetPowerToysSettingsPath()
        $SettingsTmpFilePath = [System.IO.Path]::GetTempFileName()

        $SettingsToRequest = @{}
        foreach ($module in $CurrentState.PSObject.Properties) {
            $moduleName = $module.Name
            # Skip utility properties
            if ($moduleName -eq "Ensure" -or $moduleName -eq "Debug") {
                continue
            }

            $moduleProperties = $module.Value
            $propertiesArray = @() 
            foreach ($property in $moduleProperties.PSObject.Properties) {
                $propertyName = $property.Name
                # Skip Enabled properties - they should be requested from GeneralSettings
                if ($propertyName -eq "Enabled") {
                    continue
                }

                $propertiesArray += $propertyName
            }

            $SettingsToRequest[$moduleName] = $propertiesArray
        }

        $settingsJson = $SettingsToRequest | ConvertTo-Json
        $settingsJson | Set-Content -Path $SettingsTmpFilePath

        Start-Process -FilePath $SettingsExePath -Wait -Args "get `"$SettingsTmpFilePath`""
        $SettingsValues = Get-Content -Path $SettingsTmpFilePath -Raw

        if ($this.Debug -eq $true) {
            $TempFilePath = Join-Path -Path $env:TEMP -ChildPath "PowerToys.DSC.TestConfigure.txt"
            Set-Content -Path "$TempFilePath" -Value ("Requested:`r`n" + $settingsJson + "`r`n" + "Got:`r`n" + $SettingsValues + "`r`n" + (Get-Date -Format "o")) -Force
        }

        $SettingsValues = $SettingsValues | ConvertFrom-Json
        foreach ($module in $SettingsValues.PSObject.Properties) {
            $moduleName = $module.Name
            $obtainedModuleSettings = $module.Value
            $moduleRef = $CurrentState.$moduleName
            foreach ($property in $obtainedModuleSettings.PSObject.Properties) {
                $propertyName = $property.Name
                $moduleRef.$propertyName = $property.Value
            }
        }

        Remove-Item -Path $SettingsTmpFilePath

        return $CurrentState
    }

    [bool] Test() {
        # NB: we must always assume that the configuration isn't applied, because changing some settings produce external side-effects
        return $false 
    }

    [void] Set() {
        $SettingsExePath = $this.GetPowerToysSettingsPath()
        $ChangesToApply = @()

        $this.AdvancedPaste.ApplyChanges([ref]$ChangesToApply)
        $this.AlwaysOnTop.ApplyChanges([ref]$ChangesToApply)
        $this.Awake.ApplyChanges([ref]$ChangesToApply)
        $this.ColorPicker.ApplyChanges([ref]$ChangesToApply)
        $this.CropAndLock.ApplyChanges([ref]$ChangesToApply)
        $this.EnvironmentVariables.ApplyChanges([ref]$ChangesToApply)
        $this.FancyZones.ApplyChanges([ref]$ChangesToApply)
        $this.FileLocksmith.ApplyChanges([ref]$ChangesToApply)
        $this.FindMyMouse.ApplyChanges([ref]$ChangesToApply)
        $this.Hosts.ApplyChanges([ref]$ChangesToApply)
        $this.ImageResizer.ApplyChanges([ref]$ChangesToApply)
        $this.KeyboardManager.ApplyChanges([ref]$ChangesToApply)
        $this.MeasureTool.ApplyChanges([ref]$ChangesToApply)
        $this.MouseHighlighter.ApplyChanges([ref]$ChangesToApply)
        $this.MouseJump.ApplyChanges([ref]$ChangesToApply)
        $this.MousePointerCrosshairs.ApplyChanges([ref]$ChangesToApply)
        $this.MouseWithoutBorders.ApplyChanges([ref]$ChangesToApply)
        $this.NewPlus.ApplyChanges([ref]$ChangesToApply)
        $this.Peek.ApplyChanges([ref]$ChangesToApply)
        $this.PowerAccent.ApplyChanges([ref]$ChangesToApply)
        $this.PowerLauncher.ApplyChanges([ref]$ChangesToApply)
        $this.PowerOcr.ApplyChanges([ref]$ChangesToApply)
        $this.PowerPreview.ApplyChanges([ref]$ChangesToApply)
        $this.PowerRename.ApplyChanges([ref]$ChangesToApply)
        $this.RegistryPreview.ApplyChanges([ref]$ChangesToApply)
        $this.ShortcutGuide.ApplyChanges([ref]$ChangesToApply)
        $this.Workspaces.ApplyChanges([ref]$ChangesToApply)
        $this.ZoomIt.ApplyChanges([ref]$ChangesToApply)
        $this.GeneralSettings.ApplyChanges([ref]$ChangesToApply)
    
        if ($this.Debug -eq $true) {
            $tmp_info = $ChangesToApply
            # $tmp_info = $this | ConvertTo-Json -Depth 10

            $TempFilePath = Join-Path -Path $env:TEMP -ChildPath "PowerToys.DSC.TestConfigure.txt"
            Set-Content -Path "$TempFilePath" -Value ($tmp_info + "`r`n" + (Get-Date -Format "o")) -Force
        } 

        # Stop any running PowerToys instances
        Stop-Process -Name "PowerToys.Settings" -Force -PassThru | Wait-Process
        $PowerToysProcessStopped = Stop-Process -Name "PowerToys" -Force -PassThru
        $PowerToysProcessStopped | Wait-Process

        foreach ($change in $ChangesToApply) {
            Start-Process -FilePath $SettingsExePath -Wait -Args "$change"
        }

        # If the PowerToys process was stopped, restart it.
        if ($PowerToysProcessStopped -ne $null) {
            Start-Process -FilePath $SettingsExePath
        }
    }
}
#endregion DscResources
# SIG # Begin signature block
# MIIoKgYJKoZIhvcNAQcCoIIoGzCCKBcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCD5OCpkUYsPg0PJ
# /2EVcSKGeYq5RIHgVQf1IdoRBy88NaCCDXYwggX0MIID3KADAgECAhMzAAAEBGx0
# Bv9XKydyAAAAAAQEMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjQwOTEyMjAxMTE0WhcNMjUwOTExMjAxMTE0WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC0KDfaY50MDqsEGdlIzDHBd6CqIMRQWW9Af1LHDDTuFjfDsvna0nEuDSYJmNyz
# NB10jpbg0lhvkT1AzfX2TLITSXwS8D+mBzGCWMM/wTpciWBV/pbjSazbzoKvRrNo
# DV/u9omOM2Eawyo5JJJdNkM2d8qzkQ0bRuRd4HarmGunSouyb9NY7egWN5E5lUc3
# a2AROzAdHdYpObpCOdeAY2P5XqtJkk79aROpzw16wCjdSn8qMzCBzR7rvH2WVkvF
# HLIxZQET1yhPb6lRmpgBQNnzidHV2Ocxjc8wNiIDzgbDkmlx54QPfw7RwQi8p1fy
# 4byhBrTjv568x8NGv3gwb0RbAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQU8huhNbETDU+ZWllL4DNMPCijEU4w
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMjkyMzAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAIjmD9IpQVvfB1QehvpC
# Ge7QeTQkKQ7j3bmDMjwSqFL4ri6ae9IFTdpywn5smmtSIyKYDn3/nHtaEn0X1NBj
# L5oP0BjAy1sqxD+uy35B+V8wv5GrxhMDJP8l2QjLtH/UglSTIhLqyt8bUAqVfyfp
# h4COMRvwwjTvChtCnUXXACuCXYHWalOoc0OU2oGN+mPJIJJxaNQc1sjBsMbGIWv3
# cmgSHkCEmrMv7yaidpePt6V+yPMik+eXw3IfZ5eNOiNgL1rZzgSJfTnvUqiaEQ0X
# dG1HbkDv9fv6CTq6m4Ty3IzLiwGSXYxRIXTxT4TYs5VxHy2uFjFXWVSL0J2ARTYL
# E4Oyl1wXDF1PX4bxg1yDMfKPHcE1Ijic5lx1KdK1SkaEJdto4hd++05J9Bf9TAmi
# u6EK6C9Oe5vRadroJCK26uCUI4zIjL/qG7mswW+qT0CW0gnR9JHkXCWNbo8ccMk1
# sJatmRoSAifbgzaYbUz8+lv+IXy5GFuAmLnNbGjacB3IMGpa+lbFgih57/fIhamq
# 5VhxgaEmn/UjWyr+cPiAFWuTVIpfsOjbEAww75wURNM1Imp9NJKye1O24EspEHmb
# DmqCUcq7NqkOKIG4PVm3hDDED/WQpzJDkvu4FrIbvyTGVU01vKsg4UfcdiZ0fQ+/
# V0hf8yrtq9CkB8iIuk5bBxuPMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
# hkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
# IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQg
# Q29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03
# a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akr
# rnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato88tt8zpcoRb0Rrrg
# OGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy
# 4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9
# sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAh
# dCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8k
# A/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTB
# w3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmn
# Eyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90
# lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0w
# ggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2o
# ynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsG
# AQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNV
# HSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKb
# C5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11l
# hJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6
# I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0
# wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560
# STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQam
# ASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGa
# J+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ah
# XJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA
# 9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33Vt
# Y5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr
# /Xmfwb1tbWrJUnMTDXpQzTGCGgowghoGAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAQEbHQG/1crJ3IAAAAABAQwDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIN7q753NpcNEQvgOQthLDsAW
# mUMaRwEDvvvDejSASHS5MEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEATvrI1cMvIy1EXyyh5ZbQtsII0HqUg1guXULJCTSoGqVwHWo+5J8Z3xnc
# PMGbVrSjxiQXpEB2zgn1n+/xEoBggiaRTEsMw7f+Id4qVzGZ2eHnet2+biblTU+s
# wfcsLpnCnG++p48AQKAEEu3eprG4hv41ODUFrnnsi9gVfhKhvZoXYxQl9C1gV7j/
# ldgZGVYCpixBIgOpdt4LQq1tBvCJifS8aH50wUCQivx9A9kRwqcAq4A5E0LLRVqN
# pPaNdf9wxH5LemOhlZ9CrV22efdoF1P37otNvkDCzOgi37vDbyk3ClQRHhK7moHF
# SYN2qFC1oBUmVy3UWqz6mf+UaoVk4KGCF5QwgheQBgorBgEEAYI3AwMBMYIXgDCC
# F3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCCNIm9U5wK4UfmmgfsTwVQUUkKQr9xEF6v/lbSI6EDexgIGZ7eo1Lp/
# GBMyMDI1MDIyNzE5NTkxMS4xMjhaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046N0YwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHqMIIHIDCCBQigAwIBAgITMwAAAgbXvFE4mCPsLAABAAACBjANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yNTAxMzAxOTQy
# NTBaFw0yNjA0MjIxOTQyNTBaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046N0YwMC0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDpRIWbIM3Rlr397cjHaYx85l7I+ZVWGMCBCM911BpU
# 6+IGWCqksqgqefZFEjKzNVDYC9YcgITAz276NGgvECm4ZfNv/FPwcaSDz7xbDbsO
# oxbwQoHUNRro+x5ubZhT6WJeU97F06+vDjAw/Yt1vWOgRTqmP/dNr9oqIbE5oCLY
# dH3wI/noYmsJVc7966n+B7UAGAWU2se3Lz+xdxnNsNX4CR6zIMVJTSezP/2STNcx
# JTu9k2sl7/vzOhxJhCQ38rdaEoqhGHrXrmVkEhSv+S00DMJc1OIXxqfbwPjMqEVp
# 7K3kmczCkbum1BOIJ2wuDAbKuJelpteNZj/S58NSQw6khfuJAluqHK3igkS/Oux4
# 9qTP+rU+PQeNuD+GtrCopFucRmanQvxISGNoxnBq3UeDTqphm6aI7GMHtFD6DOjJ
# lllH1gVWXPTyivf+4tN8TmO6yIgB4uP00bH9jn/dyyxSjxPQ2nGvZtgtqnvq3h3T
# RjRnkc+e1XB1uatDa1zUcS7r3iodTpyATe2hgkVX3m4DhRzI6A4SJ6fbJM9isLH8
# AGKcymisKzYupAeFSTJ10JEFa6MjHQYYohoCF77R0CCwMNjvE4XfLHu+qKPY8GQf
# sZdigQ9clUAiydFmVt61hytoxZP7LmXbzjD0VecyzZoL4Equ1XszBsulAr5Ld2Kw
# cwIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFO0wsLKdDGpT97cx3Iymyo/SBm4SMB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQB23GZOfe9ThTUvD29i4t6lDpxJhpVRMme+
# UbyZhBFCZhoGTtjDdphAArU2Q61WYg3YVcl2RdJm5PUbZ2bA77zk+qtLxC+3dNxV
# sTcdtxPDSSWgwBHxTj6pCmoDNXolAYsWpvHQFCHDqEfAiBxX1dmaXbiTP1d0Xffv
# gR6dshUcqaH/mFfjDZAxLU1s6HcVgCvBQJlJ7xEG5jFKdtqapKWcbUHwTVqXQGbI
# lHVClNJ3yqW6Z3UJH/CFcYiLV/e68urTmGtiZxGSYb4SBSPArTrTYeHOlQIj/7lo
# VWmfWX2y4AGV/D+MzyZMyvFw4VyL0Vgq96EzQKyteiVeBaVEjxQKo3AcPULRF4Uz
# z98P2tCM5XbFZ3Qoj9PLg3rgFXr0oJEhfh2tqUrhTJd13+i4/fek9zWicoshlwXg
# Fu002ZWBVzASEFuqED48qyulZ/2jGJBcta+Fdk2loP2K3oSj4PQQe1MzzVZO52AX
# O42MHlhm3SHo3/RhQ+I1A0Ny+9uAehkQH6LrxkrVNvZG4f0PAKMbqUcXG7xznKJ0
# x0HYr5ayWGbHKZRcObU+/34ZpL9NrXOedVDXmSd2ylKSl/vvi1QwNJqXJl/+gJkQ
# EetqmHAUFQkFtemi8MUXQG2w/RDHXXwWAjE+qIDZLQ/k4z2Z216tWaR6RDKHGkwe
# CoDtQtzkHTCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
# hvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# MjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAy
# MDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25Phdg
# M/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPF
# dvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6
# GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBp
# Dco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50Zu
# yjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3E
# XzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0
# lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1q
# GFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ
# +QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PA
# PBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkw
# EgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxG
# NSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARV
# MFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAK
# BggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG
# 9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0x
# M7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmC
# VgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449
# xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wM
# nosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDS
# PeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2d
# Y3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxn
# GSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+Crvs
# QWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokL
# jzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNN
# MIICNQIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjdGMDAtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQAE
# a0f118XHM/VNdqKBs4QXxNnN96CBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA62q4sDAiGA8yMDI1MDIyNzEwMTA1
# NloYDzIwMjUwMjI4MTAxMDU2WjB0MDoGCisGAQQBhFkKBAExLDAqMAoCBQDrariw
# AgEAMAcCAQACAi+uMAcCAQACAhQCMAoCBQDrbAowAgEAMDYGCisGAQQBhFkKBAIx
# KDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZI
# hvcNAQELBQADggEBAJjJzmeK15YUFfVeqoRi9od59Jxte7BecNtOVMEJYzqp3Rzb
# 1WEBpGcSxjXmghQYfL1pEJDDQ9BIJbp4lFevVqjnAh0Q8xTWSBNAWzN1uyenH3jW
# llskWf7RnEi/wZAjNzMgNbUyNoT55pJlUb9ZFxXagAmjk8KgukmZgMWd0nYG5JnG
# plx/dLl/dfL79H5aL3BwK5fB4sq+hlsCsVCKA6kOF9l1VlnZ9fC9MHeSC5FEzS/2
# Wuk8KE7I06AejV8A8mKo7N3zOaLvCKiW7KVRFOqkwGlEJhy9Psz6D+CI/SCSsT2Y
# LEqqcmFM3fmextSI+9QFnmTEqXX17wcQEJd4UaoxggQNMIIECQIBATCBkzB8MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNy
# b3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAgbXvFE4mCPsLAABAAACBjAN
# BglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8G
# CSqGSIb3DQEJBDEiBCAm4PnPzgFKYwKwknAgug5ELxashgLKFsAalILIEpzSUzCB
# +gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIODo9ZSIkZ6dVtKT+E/uZx2WAy7K
# iXM5R1JIOhNJf0vSMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAAIG17xROJgj7CwAAQAAAgYwIgQgdVph0bat8iX8u9cozvLiw5TJynWZ
# af6EKW+tUmqiWlkwDQYJKoZIhvcNAQELBQAEggIANiH7662HraOfKziMa8ALbuoe
# AKU0XEYi318MdD3+CejfJSfi9ACRSAxG46b34k8PTYLSNE7wyyUzCNEomg4Sf1ti
# 3baHcIcr4BatgEL3OLTnWR8RfMc507POkUV/ILl3lN2Ow/hwTjGiFW+H086NXKIY
# sz7o5ORVTmla4RLiy8ihw+NRW+4RsRueLZGiitDOS3GgDPBmDqvmAwU1+JO8cQa8
# YVcwzM9hv+Qbv3DquXaTeIHKaephO4nAEv4/SCsdm2Z9o5zMyQUss+VlENjILkUL
# /tdtj5X4+FxBGaNr6Apb7oyBCtz79Yum6tLpYxKe9JnKkbWYxpKqqkjCA9f8VH/p
# YHmIQcA9zKYYKuOeqPI5eal551673PgygR0DEWu2FW7EQs35C+RQHYUCiz5eRH0G
# LHsLER3mLGRDdUn7Qxsh1yqF0nzIU0R5cHq5q9/u/gfrOKmfKB1/oCajMVk2bVvR
# qd0AFVKCTfE8Jxpq4eSS1f4+XoQyojgZeRu6tlPg/7o/4nU1MzANolqB0JDV5bpe
# C/UuMgYXaxgUOT/Aeg153PN3Dyrl5l2E4BpFBfsx9ted9+qbOcv/eaBMl7Ijkz6M
# cEeLFOhKNaLIZJA+Azx9q1dAxItTE/KmwyXS4CXPyApwrbwVtbYTKznmF0HJsH9c
# zwp6r0sPbnPr8OqAZDg=
# SIG # End signature block
