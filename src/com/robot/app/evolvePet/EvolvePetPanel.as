package com.robot.app.evolvePet
{
   import com.robot.app.petUpdate.PetUpdatePropController;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.EvolveXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class EvolvePetPanel extends Sprite
   {
      private const SPACE:uint = 120;
      
      private const ITEMSPACE:uint = 90;
      
      private const PATH:String = "module/evolvePet/evolvePetUI.swf";
      
      private var mainMC:MovieClip;
      
      private var petContainer:MovieClip;
      
      private var itemContainer:MovieClip;
      
      private var petArray:Array;
      
      private var itemArray:Array;
      
      private var petMCArray:Array;
      
      private var hasSubmit:Boolean = false;
      
      private var index:uint = 0;
      
      private var pageCount:uint = 0;
      
      private var closeBtn:SimpleButton;
      
      private var prevBtn:SimpleButton;
      
      private var nextBtn:SimpleButton;
      
      private var evolveBtn:SimpleButton;
      
      private var currentPetMC:MovieClip;
      
      private var newPetMC:MovieClip;
      
      private var evolveIndex:uint = 0;
      
      public function EvolvePetPanel()
      {
         super();
      }
      
      public function show() : void
      {
         if(Boolean(this.mainMC))
         {
            this.init();
         }
         else
         {
            this.loadUI();
         }
      }
      
      private function loadUI() : void
      {
         var url:String = ClientConfig.getResPath(this.PATH);
         var mcloader:MCLoader = new MCLoader(url,LevelManager.appLevel,1,"正在打开进化程序");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         mcloader.doLoad();
      }
      
      private function onLoadSuccess(event:MCLoadEvent) : void
      {
         var mcloader:MCLoader = event.currentTarget as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         var cls:Class = event.getApplicationDomain().getDefinition("mainUI") as Class;
         this.mainMC = new cls() as MovieClip;
         this.petContainer = this.mainMC["petContainer"];
         this.itemContainer = this.mainMC["itemContainer"];
         this.closeBtn = this.mainMC["closeBtn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.close);
         this.prevBtn = this.mainMC["prevBtn"];
         this.nextBtn = this.mainMC["nextBtn"];
         this.prevBtn.addEventListener(MouseEvent.CLICK,this.prevHandler);
         this.nextBtn.addEventListener(MouseEvent.CLICK,this.nextHandler);
         this.evolveBtn = this.mainMC["evolveBtn"];
         this.evolveBtn.addEventListener(MouseEvent.CLICK,this.evolveHandler);
         mcloader.clear();
         this.init();
      }
      
      private function onUpdateProp(event:SocketEvent) : void
      {
         var mc:MovieClip = null;
         this.hasSubmit = true;
         this.evolveBtn.mouseEnabled = false;
         this.currentPetMC = null;
         this.newPetMC = null;
         SocketConnection.removeCmdListener(CommandID.NOTE_UPDATE_PROP,this.onUpdateProp);
         if(!this.stage)
         {
            return;
         }
         mc = this.mainMC["effectMC"];
         mc.gotoAndPlay(2);
         mc.addFrameScript(114,function():void
         {
            close(null);
            PetUpdatePropController.owner.show(true);
            mc.addFrameScript(114,null);
         });
      }
      
      private function evolveHandler(event:MouseEvent) : void
      {
         var info:PetInfo = null;
         if(this.evolveIndex == 0)
         {
            Alarm.show("你没有选择进化的分支条件哦！继续努力");
            this.close(null);
         }
         else
         {
            info = this.petArray[this.pageCount] as PetInfo;
            trace(info.catchTime);
            SocketConnection.addCmdListener(CommandID.NOTE_UPDATE_PROP,this.onUpdateProp);
            SocketConnection.send(CommandID.PET_EVOLVTION,info.catchTime,this.evolveIndex);
         }
      }
      
      private function init() : void
      {
         var i:PetInfo = null;
         var flag:uint = 0;
         if(!this.evolveBtn.mouseEnabled)
         {
            this.evolveBtn.mouseEnabled = true;
         }
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.onItemData);
         ItemManager.getCollection();
         this.mainMC["effectMC"].gotoAndStop(1);
         this.petContainer.x = 134;
         this.petContainer.y = 300;
         this.index = 0;
         this.pageCount = 0;
         this.petArray = [];
         this.petMCArray = [];
         this.addChild(this.mainMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(this);
         var arr:Array = PetManager.infos;
         for each(i in PetManager.infos)
         {
            flag = uint(PetXMLInfo.getEvolvFlag(i.id));
            if(flag != 0)
            {
               this.petArray.push(i);
            }
         }
         if(this.petArray.length == 0)
         {
            Alarm.show("你没有可进化的精灵哦！");
            this.close(null);
         }
         this.resetBtn();
         this.prevBtn.mouseEnabled = false;
         this.prevBtn.alpha = 0.5;
         if(this.petArray.length == 1)
         {
            this.prevBtn.mouseEnabled = false;
            this.prevBtn.alpha = 0.5;
            this.nextBtn.mouseEnabled = false;
            this.nextBtn.alpha = 0.5;
         }
      }
      
      private function close(event:MouseEvent) : void
      {
         DisplayUtil.removeAllChild(this.petContainer);
         DisplayUtil.removeForParent(this);
      }
      
      private function showName() : void
      {
         var info:PetInfo = this.petArray[this.pageCount] as PetInfo;
         this.mainMC["nameTxt"].text = PetXMLInfo.getName(info.id);
         trace("切换时",info.catchTime);
      }
      
      private function loadPet() : void
      {
         if(this.index > this.petArray.length - 1)
         {
            return;
         }
         var info:PetInfo = this.petArray[this.index] as PetInfo;
         ResourceManager.getResource(ClientConfig.getPetSwfPath(info.id),this.onLoadPet,"pet");
      }
      
      private function loadItemByPet(info:PetInfo) : void
      {
         var flag:uint = uint(PetXMLInfo.getEvolvFlag(info.id));
         var evolveType:Array = EvolveXMLInfo.getMonToIDs(flag);
         this.loadItem(evolveType);
      }
      
      private function loadItem(arr:Array) : void
      {
         var i:uint;
         var obj:Object = null;
         var info:SingleItemInfo = null;
         DisplayUtil.removeAllChild(this.itemContainer);
         for(i = 0; i < arr.length; i++)
         {
            obj = arr[i];
            if(obj.EvolvItem != 0 && obj.EvolvItemCount != 0)
            {
               try
               {
                  info = ItemManager.getInfo(obj.EvolvItem);
                  ResourceManager.getResource(ItemXMLInfo.getIconURL(obj.EvolvItem),this.onLoad(obj,info,i),"item");
               }
               catch(e:Error)
               {
                  trace("没有得到详细的道具信息" + e.message);
               }
               continue;
            }
            this.evolveIndex = 1;
         }
         trace(this.itemContainer.width);
      }
      
      private function onLoad(obj:Object, info:SingleItemInfo, index:uint) : Function
      {
         var func:Function = function(o:DisplayObject):void
         {
            var oo:MovieClip = null;
            var nooo:MovieClip = null;
            try
            {
               oo = o as MovieClip;
               oo.x = ITEMSPACE * index;
               oo.buttonMode = true;
               ToolTipManager.add(oo,ItemXMLInfo.getName(obj.EvolvItem) + " " + info.itemNum + "/" + obj.EvolvItemCount);
               if(info.itemNum < obj.EvolvItemCount)
               {
                  oo.filters = [ColorFilter.setGrayscale()];
               }
               oo.addEventListener(MouseEvent.CLICK,evolveFirstHandler(obj,info,index));
               itemContainer.addChild(oo);
            }
            catch(e:Error)
            {
               nooo = o as MovieClip;
               nooo.x = ITEMSPACE * index;
               nooo.buttonMode = true;
               ToolTipManager.add(nooo,ItemXMLInfo.getName(obj.EvolvItem) + " 0/" + obj.EvolvItemCount);
               nooo.filters = [ColorFilter.setGrayscale()];
               oo.addEventListener(MouseEvent.CLICK,evolveFirstHandler(obj,info,index));
               itemContainer.addChild(nooo);
            }
         };
         return func;
      }
      
      private function evolveFirstHandler(obj:Object, info:SingleItemInfo, index:uint) : Function
      {
         var func:Function = function(e:MouseEvent):void
         {
            try
            {
               if(info.itemNum < obj.EvolvItemCount)
               {
                  Alarm.show("你拥有的数量不够！少于要求量，请继续努力，去积累吧！");
               }
               else
               {
                  evolveIndex = index + 1;
                  ResourceManager.getResource(ClientConfig.getPetSwfPath(obj.MonTo),onPreViewLoadPet,"pet");
                  trace("进化区间为：  " + evolveIndex + "\n预览精灵路径   " + ClientConfig.getPetSwfPath(obj.MonTo));
               }
            }
            catch(e:Error)
            {
               Alarm.show("你没有该物品，请继续努力，去积累吧！");
            }
         };
         return func;
      }
      
      private function replaceMC(oldMC:MovieClip, newMC:MovieClip) : void
      {
         var currentPetMCIndex:int = this.petContainer.getChildIndex(oldMC);
         this.petContainer.removeChildAt(currentPetMCIndex);
         newMC.x = oldMC.x;
         this.petContainer.addChildAt(newMC,currentPetMCIndex);
      }
      
      private function onPreViewLoadPet(o:DisplayObject) : void
      {
         if(this.hasSubmit || this.currentPetMC == null || this.currentPetMC != this.petMCArray[this.pageCount] as MovieClip)
         {
            this.hasSubmit = false;
            this.newPetMC = o as MovieClip;
            if(Boolean(this.newPetMC))
            {
               this.newPetMC.gotoAndStop("rightdown");
               this.newPetMC.addEventListener(Event.ENTER_FRAME,function():void
               {
                  var mc:MovieClip = newPetMC.getChildAt(0) as MovieClip;
                  if(Boolean(mc))
                  {
                     mc.gotoAndStop(1);
                     newPetMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  }
               });
               this.newPetMC.scaleX = 3;
               this.newPetMC.scaleY = 3;
            }
            this.currentPetMC = this.petMCArray[this.pageCount] as MovieClip;
            this.replaceMC(this.currentPetMC,this.newPetMC);
         }
         else if(this.currentPetMC == this.petMCArray[this.pageCount] as MovieClip)
         {
            this.replaceMC(this.newPetMC,this.currentPetMC);
            this.currentPetMC = this.petMCArray[this.pageCount] as MovieClip;
            this.newPetMC = o as MovieClip;
            if(Boolean(this.newPetMC))
            {
               this.newPetMC.gotoAndStop("rightdown");
               this.newPetMC.addEventListener(Event.ENTER_FRAME,function():void
               {
                  var mc:MovieClip = newPetMC.getChildAt(0) as MovieClip;
                  if(Boolean(mc))
                  {
                     mc.gotoAndStop(1);
                     newPetMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  }
               });
               this.newPetMC.scaleX = 3;
               this.newPetMC.scaleY = 3;
            }
            this.replaceMC(this.currentPetMC,this.newPetMC);
         }
      }
      
      private function onItemData(event:ItemEvent) : void
      {
         if(this.petArray.length > 0)
         {
            this.loadPet();
            this.showName();
            this.loadItemByPet(this.petArray[this.pageCount]);
         }
      }
      
      private function onLoadPet(o:DisplayObject) : void
      {
         var _showMc:MovieClip = null;
         _showMc = o as MovieClip;
         if(Boolean(_showMc))
         {
            _showMc.gotoAndStop("rightdown");
            _showMc.addEventListener(Event.ENTER_FRAME,function():void
            {
               var mc:MovieClip = _showMc.getChildAt(0) as MovieClip;
               if(Boolean(mc))
               {
                  mc.gotoAndStop(1);
                  _showMc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
            _showMc.scaleX = 3;
            _showMc.scaleY = 3;
            _showMc.x = this.SPACE * this.index;
            this.petContainer.addChild(_showMc);
         }
         this.petMCArray.push(_showMc);
         ++this.index;
         this.loadPet();
      }
      
      private function revertPet() : void
      {
         if(this.currentPetMC != null && this.newPetMC != null)
         {
            this.replaceMC(this.newPetMC,this.currentPetMC);
            this.currentPetMC = null;
            this.newPetMC = null;
         }
      }
      
      private function prevHandler(event:MouseEvent) : void
      {
         this.resetBtn();
         this.revertPet();
         --this.pageCount;
         this.showName();
         this.loadItemByPet(this.petArray[this.pageCount]);
         TweenLite.to(this.petContainer,0.2,{"x":this.petContainer.x + this.SPACE});
         if(this.pageCount == 0)
         {
            this.prevBtn.mouseEnabled = false;
            this.prevBtn.alpha = 0.5;
         }
      }
      
      private function nextHandler(event:MouseEvent) : void
      {
         this.resetBtn();
         this.revertPet();
         ++this.pageCount;
         this.showName();
         this.loadItemByPet(this.petArray[this.pageCount]);
         TweenLite.to(this.petContainer,0.2,{"x":this.petContainer.x - this.SPACE});
         if(this.pageCount == this.petArray.length - 1)
         {
            this.nextBtn.mouseEnabled = false;
            this.nextBtn.alpha = 0.5;
         }
      }
      
      private function resetBtn() : void
      {
         this.prevBtn.mouseEnabled = true;
         this.prevBtn.alpha = 1;
         this.nextBtn.mouseEnabled = true;
         this.nextBtn.alpha = 1;
      }
   }
}

