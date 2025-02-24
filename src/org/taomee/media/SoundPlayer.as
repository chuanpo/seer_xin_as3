package org.taomee.media
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   
   public class SoundPlayer extends EventDispatcher
   {
      private var _position:Number = 0;
      
      private var _sound:Sound;
      
      private var _soundChannel:SoundChannel;
      
      private var _soundState:int = SoundPlayerState.NOTLOADED;
      
      private var _cyc:Boolean;
      
      private var _url:String = "";
      
      private var _autoStart:Boolean;
      
      public function SoundPlayer(url:String = "", autoStart:Boolean = false, cyc:Boolean = false)
      {
         super();
         load(url,autoStart,cyc);
      }
      
      public function destroy() : void
      {
         stop();
         _sound = null;
         _soundChannel = null;
      }
      
      public function play() : void
      {
         if(_url == "")
         {
            return;
         }
         if(_soundState == SoundPlayerState.PLAYING)
         {
            return;
         }
         if(Boolean(_soundChannel))
         {
            _soundChannel.stop();
            _soundChannel.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
            _soundChannel = null;
         }
         _soundChannel = _sound.play(_position);
         _soundChannel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
         _soundState = SoundPlayerState.PLAYING;
      }
      
      public function get leftPeak() : Number
      {
         return _soundChannel.leftPeak;
      }
      
      public function stop() : void
      {
         if(_soundState == SoundPlayerState.NOTLOADED)
         {
            return;
         }
         if(_soundChannel == null)
         {
            _soundState = SoundPlayerState.STOPPED;
            return;
         }
         _position = 0;
         _soundChannel.stop();
         _soundChannel.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
         _soundState = SoundPlayerState.STOPPED;
      }
      
      private function onLoadOpen(e:Event) : void
      {
         _sound.removeEventListener(Event.OPEN,onLoadOpen);
         dispatchEvent(e);
         if(_autoStart)
         {
            if(_soundState == SoundPlayerState.PAUSED)
            {
               return;
            }
            if(_soundState == SoundPlayerState.STOPPED)
            {
               return;
            }
            _position = 0;
            play();
         }
      }
      
      public function set position(value:Number) : void
      {
         var wasPlaying:Boolean = _soundState == SoundPlayerState.PLAYING;
         pause();
         _position = value;
         if(wasPlaying)
         {
            play();
         }
      }
      
      public function get duration() : Number
      {
         return _sound.length;
      }
      
      private function onSoundComplete(e:Event) : void
      {
         stop();
         dispatchEvent(e);
         if(_cyc)
         {
            play();
         }
      }
      
      public function get volume() : Number
      {
         return _soundChannel.soundTransform.volume;
      }
      
      public function get rightPeak() : Number
      {
         return _soundChannel.rightPeak;
      }
      
      public function get position() : Number
      {
         return _soundChannel.position;
      }
      
      public function set autoStart(v:Boolean) : void
      {
         _autoStart = v;
      }
      
      public function get url() : String
      {
         return _url;
      }
      
      public function set cyc(v:Boolean) : void
      {
         _cyc = v;
      }
      
      public function get autoStart() : Boolean
      {
         return _autoStart;
      }
      
      public function set volume(value:Number) : void
      {
         var transform:SoundTransform = _soundChannel.soundTransform;
         transform.volume = value;
         _soundChannel.soundTransform = transform;
      }
      
      public function load(url:String, autoStart:Boolean = false, cyc:Boolean = false) : void
      {
         if(url == null)
         {
            return;
         }
         if(url == "")
         {
            return;
         }
         if(url == _url)
         {
            return;
         }
         _url = url;
         _sound = new Sound();
         _sound.load(new URLRequest(url));
         _sound.addEventListener(Event.OPEN,onLoadOpen);
         _sound.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
         _sound.addEventListener(Event.COMPLETE,onLoadComplete);
         _autoStart = autoStart;
         _cyc = cyc;
      }
      
      public function pause() : void
      {
         if(_soundState == SoundPlayerState.NOTLOADED)
         {
            return;
         }
         if(_soundChannel == null)
         {
            _soundState = SoundPlayerState.PAUSED;
            return;
         }
         if(_soundState == SoundPlayerState.PAUSED)
         {
            return;
         }
         _position = _soundChannel.position;
         _soundChannel.stop();
         _soundChannel.removeEventListener(Event.SOUND_COMPLETE,onSoundComplete);
         _soundState = SoundPlayerState.PAUSED;
      }
      
      private function onLoadProgress(e:ProgressEvent) : void
      {
         dispatchEvent(e);
      }
      
      public function get cyc() : Boolean
      {
         return _cyc;
      }
      
      private function onLoadComplete(e:Event) : void
      {
         _sound.removeEventListener(ProgressEvent.PROGRESS,onLoadProgress);
         _sound.removeEventListener(Event.COMPLETE,onLoadComplete);
         dispatchEvent(e);
      }
   }
}

