package com.robot.app.sceneInteraction
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.MapXMLInfo;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.mode.NonoModel;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class RoomMachShow
   {
      private var _nono:NonoModel;
      
      private var _info:NonoInfo;
      
      public function RoomMachShow(userID:uint)
      {
         super();
         if(userID == MainManager.actorID)
         {
            NonoManager.addEventListener(NonoEvent.GET_INFO,this.onMyNonoInfo);
            NonoManager.getInfo(true);
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.NONO_INFO,this.onNonoInfo);
            SocketConnection.send(CommandID.NONO_INFO,userID);
         }
         NonoManager.addEventListener(NonoEvent.FOLLOW,this.onNonoFollow);
         NonoManager.addEventListener(NonoEvent.HOOM,this.onNonoHoom);
      }
      
      public function destroy() : void
      {
         NonoManager.removeEventListener(NonoEvent.FOLLOW,this.onNonoFollow);
         NonoManager.removeEventListener(NonoEvent.HOOM,this.onNonoHoom);
         NonoManager.removeEventListener(NonoEvent.GET_INFO,this.onMyNonoInfo);
         SocketConnection.removeCmdListener(CommandID.NONO_INFO,this.onNonoInfo);
         if(Boolean(this._nono))
         {
            this._nono.destroy();
            this._nono = null;
         }
      }
      
      private function init(info:NonoInfo) : void
      {
         this._info = info;
         if(this._info.flag.length == 0)
         {
            return;
         }
         if(!this._info.flag[0])
         {
            return;
         }
         if(!this._info.state[1])
         {
            this.showNono(this._info);
         }
      }
      
      private function showNono(info:NonoInfo) : void
      {
         if(this._nono == null)
         {
            this._nono = new NonoModel(info);
            this._nono.pos = MapXMLInfo.getDefaultPos(MapManager.getResMapID(MainManager.actorInfo.mapID));
            MapManager.currentMap.depthLevel.addChild(this._nono);
         }
      }
      
      private function onNonoInfo(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.NONO_INFO,this.onNonoInfo);
         var info:NonoInfo = new NonoInfo(e.data as ByteArray);
         this.init(info);
      }
      
      private function onMyNonoInfo(e:NonoEvent) : void
      {
         NonoManager.removeEventListener(NonoEvent.GET_INFO,this.onMyNonoInfo);
         this.init(e.info);
      }
      
      private function onNonoFollow(e:NonoEvent) : void
      {
         this._info.state[1] = true;
         if(Boolean(this._nono))
         {
            this._nono.destroy();
            this._nono = null;
         }
      }
      
      private function onNonoHoom(e:NonoEvent) : void
      {
         this._info.state[1] = false;
         this.showNono(this._info);
      }
   }
}

