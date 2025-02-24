package com.robot.app.picturebook.ui
{
   import com.robot.app.picturebook.info.PictureBookInfo;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetBookXMLInfo;
   import com.robot.core.info.pet.PetBargeListInfo;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.uic.UIPanel;
   import com.robot.core.uic.UIScrollBar;
   import com.robot.core.utils.Direction;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.net.URLRequest;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MovieClipUtil;
   import org.taomee.utils.StringUtil;
   
   public class PictureBookPanel extends UIPanel
   {
      private static const LIST_LENGTH:int = 10;
      
      private const STXT:String = "输入ID或名称";
      
      private var _stxt:TextField;
      
      private var _ptxt:TextField;
      
      private var _showMc:MovieClip;
      
      private var _searchTxt:TextField;
      
      private var _searchBtn:SimpleButton;
      
      private var _listCon:Sprite;
      
      private var _leftBtn:SimpleButton;
      
      private var _rightBtn:SimpleButton;
      
      private var _dataList:Array;
      
      private var _len:int;
      
      private var _showMap:HashMap;
      
      private var _scrollBar:UIScrollBar;
      
      private var _soundBtn:SimpleButton;
      
      private var _sound:Sound;
      
      private var _soundC:SoundChannel;
      
      private const PATH_STR:String = "resource/pet/sound/";
      
      private var _url:String = "";
      
      private var _petId:uint;
      
      private const DIR_A:Array=[];
      
      private var _index:uint;
      
      public function PictureBookPanel()
      {
         var item:PictureBookListItem = null;
         this._showMap = new HashMap();
         this.DIR_A = [Direction.DOWN,Direction.LEFT_DOWN,Direction.LEFT_UP,Direction.UP,Direction.RIGHT_UP,Direction.RIGHT_DOWN];
         super(UIManager.getSprite("PictureBookMc"));
         this._stxt = _mainUI["stxt"];
         this._ptxt = _mainUI["ptxt"];
         this._searchTxt = _mainUI["searchTxt"];
         this._searchBtn = _mainUI["searchBtn"];
         this._dataList = PetBookXMLInfo.dataList;
         this._len = this._dataList.length;
         this._leftBtn = _mainUI["leftBtn"];
         this._rightBtn = _mainUI["rightBtn"];
         this._soundBtn = _mainUI["soundBtn"];
         this._listCon = new Sprite();
         this._listCon.x = 322;
         this._listCon.y = 109;
         addChild(this._listCon);
         for(var i:int = 0; i < LIST_LENGTH; i++)
         {
            item = new PictureBookListItem();
            item.index = i;
            item.id = i + 1;
            item.text = StringUtil.renewZero(this._dataList[i].@ID.toString(),3) + ":" + "---";
            item.y = (item.height + 1) * i;
            item.addEventListener(MouseEvent.CLICK,this.onItemClick);
            this._listCon.addChild(item);
         }
         this._scrollBar = new UIScrollBar(_mainUI["barBlock"],_mainUI["barBack"],LIST_LENGTH,_mainUI["upBtn"],_mainUI["downBtn"]);
         this._scrollBar.wheelObject = this;
         this.showInfo(this._listCon.getChildAt(0) as PictureBookListItem);
         this._searchTxt.text = this.STXT;
         this._searchTxt.textColor = 16777215;
      }
      
      public function show() : void
      {
         _show();
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(this._url != "")
         {
            ResourceManager.cancel(this._url,this.onLoadRes);
         }
         if(Boolean(this._soundC))
         {
            this._soundC.stop();
            this._soundC = null;
            this._sound = null;
         }
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         SocketConnection.addCmdListener(CommandID.PET_BARGE_LIST,this.onPetBarge);
         SocketConnection.send(CommandID.PET_BARGE_LIST,1,this._len);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.onSearch);
         this._searchTxt.addEventListener(FocusEvent.FOCUS_IN,this.onSFin);
         this._searchTxt.addEventListener(FocusEvent.FOCUS_OUT,this.onSFout);
         this._scrollBar.addEventListener(MouseEvent.MOUSE_MOVE,this.onBarBallMove);
         this._leftBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onRotatePetHandler);
         this._rightBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onRotatePetHandler);
         this._soundBtn.addEventListener(MouseEvent.CLICK,this.onPlaySoundHandler);
      }
      
      private function onPlaySoundHandler(e:MouseEvent) : void
      {
         if(Boolean(this._soundC))
         {
            this._soundC.stop();
            this._soundC = null;
            this._sound = null;
         }
         this._sound = new Sound();
         this._sound.load(new URLRequest(this.PATH_STR + this._petId + ".mp3"));
         this._soundC = this._sound.play();
      }
      
      private function onRotatePetHandler(e:MouseEvent) : void
      {
         var dir:String = null;
         if(!this._showMc)
         {
            return;
         }
         this._showMc.removeEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
         var label:String = this._showMc.currentLabel;
         var btn:SimpleButton = e.currentTarget as SimpleButton;
         var dirIndex:uint = uint(this.DIR_A.indexOf(label));
         if(btn == this._leftBtn)
         {
            dir = this.DIR_A[dirIndex + 1];
            if(dirIndex + 1 > this.DIR_A.length)
            {
               dir = this.DIR_A[0];
            }
         }
         else
         {
            dir = this.DIR_A[dirIndex - 1];
            if(dirIndex - 1 < 0)
            {
               dir = this.DIR_A[this.DIR_A.length - 1];
            }
         }
         this._showMc.gotoAndStop(dir);
         DisplayUtil.stopAllMovieClip(this._showMc);
         this._showMc.addEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
      }
      
      private function onPetEnterHandler(e:Event) : void
      {
         var mc:MovieClip = this._showMc.getChildAt(0) as MovieClip;
         if(Boolean(mc))
         {
            this._showMc.removeEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
            DisplayUtil.stopAllMovieClip(this._showMc);
         }
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         SocketConnection.removeCmdListener(CommandID.PET_BARGE_LIST,this.onPetBarge);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.onSearch);
         this._scrollBar.removeEventListener(MouseEvent.MOUSE_MOVE,this.onBarBallMove);
         this._leftBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRotatePetHandler);
         this._rightBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRotatePetHandler);
         this._showMc.removeEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
         this._soundBtn.removeEventListener(MouseEvent.CLICK,this.onPlaySoundHandler);
      }
      
      private function checkItem(item:PictureBookListItem) : void
      {
         var info:PictureBookInfo = this._showMap.getValue(item.id) as PictureBookInfo;
         if(Boolean(info))
         {
            item.isShow = true;
            item.hasPet(info.isCacth);
            item.text = StringUtil.renewZero(item.id.toString(),3) + ":" + PetBookXMLInfo.getName(item.id);
         }
         else
         {
            item.isShow = false;
            item.hasPet(false);
            item.text = StringUtil.renewZero(item.id.toString(),3) + ":" + "— — — —";
         }
      }
      
      private function showInfo(item:PictureBookListItem) : void
      {
         var rStr:String = null;
         if(this._url != "")
         {
            ResourceManager.cancel(this._url,this.onLoadRes);
         }
         this._stxt.text = "";
         this._ptxt.text = "";
         if(Boolean(this._showMc))
         {
            this._showMc.removeEventListener(Event.ENTER_FRAME,this.onPetEnterHandler);
            DisplayUtil.removeForParent(this._showMc);
            this._showMc = null;
         }
         this._petId = item.id;
         if(item.isShow)
         {
            this._stxt.htmlText = StringUtil.renewZero(item.id.toString(),3) + ":" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getName(item.id) + "</font>\n";
            this._stxt.htmlText += "属性:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getType(item.id) + "</font>\n";
            this._stxt.htmlText += "身高:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getHeight(item.id) + " cm" + "</font>\n";
            this._stxt.htmlText += "体重:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getWeight(item.id) + " kg" + "</font>\n";
            this._stxt.htmlText += "分布:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getFoundin(item.id) + "</font>\n";
            this._stxt.htmlText += "喜欢的食物:" + "<font color=\'#ffff00\'>" + PetBookXMLInfo.food(item.id) + "</font>\n";
            if(PetBookXMLInfo.hasSound(item.id))
            {
               this._stxt.htmlText += "声音:";
               this._soundBtn.visible = true;
            }
            else
            {
               this._soundBtn.visible = false;
            }
            this._ptxt.htmlText = "精灵简介:\n    " + "<font color=\'#ffff00\'>" + PetBookXMLInfo.getFeatures(item.id) + "</font>\n";
            this._url = ClientConfig.getPetSwfPath(item.id);
         }
         else
         {
            this._soundBtn.visible = false;
            rStr = "<font color=\'#ffff00\'>" + "？？？" + "</font>\n";
            this._stxt.htmlText = StringUtil.renewZero(item.id.toString(),3) + ":" + rStr + "\n";
            this._stxt.htmlText += "属性:" + rStr + "\n";
            this._stxt.htmlText += "身高:" + rStr + "\n";
            this._stxt.htmlText += "体重:" + rStr + "\n";
            this._stxt.htmlText += "分布:" + rStr + "\n";
            this._ptxt.htmlText += "精灵简介:\n    " + rStr;
            this._url = ClientConfig.getPetSwfPath(0);
         }
         ResourceManager.getResource(this._url,this.onLoadRes,"pet");
      }
      
      private function onLoadRes(o:DisplayObject) : void
      {
         this._showMc = o as MovieClip;
         this._showMc.x = 92;
         this._showMc.y = 150;
         this._showMc.scaleX = 2;
         this._showMc.scaleY = 2;
         _mainUI.addChildAt(this._showMc,_mainUI.getChildIndex(this._rightBtn));
         _mainUI.addChildAt(this._showMc,_mainUI.getChildIndex(this._leftBtn));
         MovieClipUtil.childStop(this._showMc,1);
         DisplayUtil.stopAllMovieClip(this._showMc);
      }
      
      private function onBarBallMove(e:MouseEvent) : void
      {
         var item:PictureBookListItem = null;
         for(var i:int = 0; i < LIST_LENGTH; i++)
         {
            item = this._listCon.getChildAt(i) as PictureBookListItem;
            item.id = i + this._scrollBar.index + 1;
            item.index = i + this._scrollBar.index;
            this.checkItem(item);
         }
      }
      
      private function onPetBarge(e:SocketEvent) : void
      {
         var info:PictureBookInfo = null;
         var item:PictureBookListItem = null;
         SocketConnection.removeCmdListener(CommandID.PET_BARGE_LIST,this.onPetBarge);
         this._showMap.clear();
         var data:ByteArray = (e.data as PetBargeListInfo).data;
         var cont:uint = data.readUnsignedInt();
         for(var i:int = 0; i < cont; i++)
         {
            info = new PictureBookInfo(data);
            this._showMap.add(info.id,info);
         }
         this._scrollBar.totalLength = this._len;
         for(var k:int = 0; k < LIST_LENGTH; k++)
         {
            item = this._listCon.getChildAt(k) as PictureBookListItem;
            this.checkItem(item);
         }
      }
      
      private function onItemClick(e:MouseEvent) : void
      {
         var item:PictureBookListItem = e.currentTarget as PictureBookListItem;
         this.showInfo(item);
      }
      
      public function serachId(i:int) : void
      {
         var item:XML = null;
         var k:int = 0;
         var i1:int = 0;
         var j:int = 0;
         var pitem:PictureBookListItem = null;
         var itemIcon:PictureBookListItem = null;
         var id:int = i;
         var index:int = -1;
         if(Boolean(id))
         {
            i = 0;
            while(true)
            {
               if(i < this._len)
               {
                  item = this._dataList[i] as XML;
                  if(int(item.@ID) != id)
                  {
                     continue;
                  }
                  index = int(item.@ID) - 1;
               }
               i++;
            }
         }
         else
         {
            for(k = 0; k < this._len; k++)
            {
               item = this._dataList[k] as XML;
               if(String(item.@DefName) == this._searchTxt.text)
               {
                  index = int(item.@ID) - 1;
                  break;
               }
            }
         }
         if(index != -1)
         {
            if(index >= LIST_LENGTH)
            {
               for(j = 0; j < LIST_LENGTH; j++)
               {
                  pitem = this._listCon.getChildAt(j) as PictureBookListItem;
                  pitem.id = j + index - index % LIST_LENGTH + 1;
                  pitem.index = j + index - index % LIST_LENGTH;
                  this.checkItem(pitem);
               }
               this._scrollBar.index = index - 9;
            }
            else
            {
               this._scrollBar.index = 0;
            }
            for(i1 = 0; i1 < LIST_LENGTH; i1++)
            {
               itemIcon = this._listCon.getChildAt(i1) as PictureBookListItem;
               if(itemIcon.id == index + 1)
               {
                  itemIcon.setSelect(true);
                  this.showInfo(itemIcon);
                  break;
               }
            }
         }
      }
      
      private function onSearch(e:MouseEvent) : void
      {
         if(this._searchTxt.text != null)
         {
            this.serachId(parseInt(this._searchTxt.text));
         }
      }
      
      private function onSFin(e:FocusEvent) : void
      {
         this._searchTxt.text = "";
         this._searchTxt.textColor = 16777215;
      }
      
      private function onSFout(e:FocusEvent) : void
      {
         if(this._searchTxt.text == "")
         {
            this._searchTxt.text = this.STXT;
            this._searchTxt.textColor = 16777215;
         }
      }
   }
}

