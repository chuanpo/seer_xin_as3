package com.robot.app.petbag.ui
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.NatureXMLInfo;
   import com.robot.core.config.xml.PetEffectXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.pet.PetEffectInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.skillBtn.NormalSkillBtn;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.StringUtil;
   
   public class PetDataPanel
   {
      private static const MAX:int = 4;
      
      private var skillBtnArray:Array = [];
      
      private var _mainUI:Sprite;
      
      private var _numTxt:TextField;
      
      private var _nameTxt:TextField;
      
      private var _levelTxt:TextField;
      
      private var _upExpTxt:TextField;
      
      private var _charaTxt:TextField;
      
      private var _getTimeTxt:TextField;
      
      private var _showMc:MovieClip;
      
      private var _attackTxt:TextField;
      
      private var _defenceTxt:TextField;
      
      private var _saTxt:TextField;
      
      private var _sdTxt:TextField;
      
      private var _speedTxt:TextField;
      
      private var _hpTxt:TextField;
      
      private var ev_attackTxt:TextField;
      
      private var ev_defenceTxt:TextField;
      
      private var ev_saTxt:TextField;
      
      private var ev_sdTxt:TextField;
      
      private var ev_speedTxt:TextField;
      
      private var ev_hpTxt:TextField;
      
      private var _id:uint;
      
      private var _petInfo:PetInfo;
      
      private var attMc:SimpleButton;
      
      private var des1:String = "<font color=\'#ffff00\'>";
      
      private var des2:String = "</font>";
      
      public function PetDataPanel(ui:Sprite)
      {
         super();
         this._mainUI = ui;
         this._numTxt = this._mainUI["numTxt"];
         this._nameTxt = this._mainUI["nameTxt"];
         this._levelTxt = this._mainUI["levelTxt"];
         this._upExpTxt = this._mainUI["upExpTxt"];
         this._charaTxt = this._mainUI["charaTxt"];
         this._getTimeTxt = this._mainUI["getTimeTxt"];
         this._attackTxt = this._mainUI["attackTxt"];
         this._defenceTxt = this._mainUI["defenceTxt"];
         this._saTxt = this._mainUI["saTxt"];
         this._sdTxt = this._mainUI["sdTxt"];
         this._speedTxt = this._mainUI["speedTxt"];
         this._hpTxt = this._mainUI["hpTxt"];
         this.ev_attackTxt = this._mainUI["ev_attackTxt"];
         this.ev_defenceTxt = this._mainUI["ev_defenceTxt"];
         this.ev_saTxt = this._mainUI["ev_saTxt"];
         this.ev_sdTxt = this._mainUI["ev_sdTxt"];
         this.ev_speedTxt = this._mainUI["ev_speedTxt"];
         this.ev_hpTxt = this._mainUI["ev_hpTxt"];
         this.addEffectBg();
         for(var i:uint = 0; i < 6; i++)
         {
            ToolTipManager.add(this._mainUI["icon_" + i],"学习力");
         }
         SocketConnection.addCmdListener(CommandID.EAT_SPECIAL_MEDICINE,this.onEatSplItem);
      }
      
      public function clearInfo() : void
      {
         this._numTxt.text = "";
         this._nameTxt.text = "";
         this._levelTxt.text = "";
         this._upExpTxt.text = "";
         this._charaTxt.text = "";
         this._getTimeTxt.text = "";
         this._attackTxt.text = "";
         this._defenceTxt.text = "";
         this._saTxt.text = "";
         this._sdTxt.text = "";
         this._speedTxt.text = "";
         this._hpTxt.text = "";
         if(this._id != 0)
         {
            ResourceManager.cancel(ClientConfig.getPetSwfPath(this._id),this.onShowComplete);
         }
         if(Boolean(this._showMc))
         {
            DisplayUtil.removeForParent(this._showMc);
            this._showMc = null;
         }
         if(Boolean(this.skillBtnArray))
         {
            this.clearOldBtn();
         }
      }
      
      public function show(info:PetInfo) : void
      {
         var skillBtn:NormalSkillBtn = null;
         this._petInfo = info;
         this._numTxt.htmlText = "序号:" + this.des1 + StringUtil.renewZero(info.id.toString(),3) + this.des2;
         this._nameTxt.htmlText = "名字:" + this.des1 + PetXMLInfo.getName(info.id) + this.des2;
         this._levelTxt.htmlText = "等级:" + this.des1 + info.level.toString() + this.des2 + ("    个体:" + this.des1) + info.dv.toString() + this.des2;
         this._upExpTxt.htmlText = "升级所需经验值:" + this.des1 + (info.nextLvExp - info.exp).toString() + this.des2;
         var effectInfo:PetEffectInfo = info.effectList[0];
         this._charaTxt.htmlText = "性格:" + this.des1 + NatureXMLInfo.getName(info.nature) + this.des2;
         if(Boolean(effectInfo))
         {
            this._charaTxt.htmlText += " 特性:" + this.des1 + PetEffectXMLInfo.getEffect(effectInfo.effectID,effectInfo.args) + this.des2;
         }
         this._getTimeTxt.htmlText = "获得时间:" + this.des1 + StringUtil.timeFormat(info.catchTime) + this.des2;
         this.showIcon(info.effectList);
         if(Boolean(this.attMc))
         {
            DisplayUtil.removeForParent(this.attMc);
            this.attMc = null;
         }
         this.attMc = UIManager.getButton("Icon_PetType_" + PetXMLInfo.getType(info.id));
         if(Boolean(this.attMc))
         {
            this.attMc.x = this._nameTxt.x + this._nameTxt.textWidth + 10;
            this.attMc.y = this._nameTxt.y;
            DisplayUtil.uniformScale(this.attMc,20);
            this._mainUI.addChild(this.attMc);
         }
         if(this._id != 0)
         {
            ResourceManager.cancel(ClientConfig.getPetSwfPath(this._id),this.onShowComplete);
         }
         if(Boolean(this._showMc))
         {
            DisplayUtil.removeForParent(this._showMc);
            this._showMc = null;
         }
         this._id = info.id;
         ResourceManager.getResource(ClientConfig.getPetSwfPath(info.id),this.onShowComplete,"pet");
         this._attackTxt.htmlText = "攻击:" + this.des1 + info.attack.toString() + this.des2;
         this._defenceTxt.htmlText = "防御:" + this.des1 + info.defence.toString() + this.des2;
         this._saTxt.htmlText = "特攻:" + this.des1 + info.s_a.toString() + this.des2;
         this._sdTxt.htmlText = "特防:" + this.des1 + info.s_d.toString() + this.des2;
         this._speedTxt.htmlText = "速度:" + this.des1 + info.speed.toString() + this.des2;
         this._hpTxt.htmlText = "体力:" + this.des1 + info.hp.toString() + this.des2;
         this.ev_attackTxt.htmlText = this.des1 + info.ev_attack.toString() + this.des2;
         this.ev_defenceTxt.htmlText = this.des1 + info.ev_defence.toString() + this.des2;
         this.ev_saTxt.htmlText = this.des1 + info.ev_sa.toString() + this.des2;
         this.ev_sdTxt.htmlText = this.des1 + info.ev_sd.toString() + this.des2;
         this.ev_speedTxt.htmlText = this.des1 + info.ev_sp.toString() + this.des2;
         this.ev_hpTxt.htmlText = this.des1 + info.ev_hp.toString() + this.des2;
         this.clearOldBtn();
         for(var i:int = 0; i < MAX; i++)
         {
            if(i < info.skillNum)
            {
               skillBtn = new NormalSkillBtn(info.skillArray[i].id,info.skillArray[i].pp);
            }
            else
            {
               skillBtn = new NormalSkillBtn();
            }
            skillBtn.x = 18 + (skillBtn.width + 10) * (i % 2);
            skillBtn.y = 218 + (skillBtn.height + 8) * Math.floor(i / 2);
            this.skillBtnArray.push(skillBtn);
            this._mainUI.addChild(skillBtn);
         }
         this._mainUI.visible = true;
      }
      
      private function addEffectBg() : void
      {
         var icon:PetEffectIcon = null;
         for(var i1:int = 0; i1 < 5; i1++)
         {
            icon = new PetEffectIcon();
            icon.name = "icon" + i1;
            this._mainUI.addChild(icon);
            icon.x = 7 + (icon.width + 3) * i1;
            icon.y = 116;
         }
      }
      
      private function showIcon(a:Array) : void
      {
         var icon:PetEffectIcon = null;
         for(var i1:int = 0; i1 < 5; i1++)
         {
            icon = this._mainUI.getChildByName("icon" + i1) as PetEffectIcon;
            icon.clear();
            if(i1 < a.length)
            {
               icon.show(a[i1] as PetEffectInfo);
            }
         }
      }
      
      private function clearOldBtn() : void
      {
         var i:NormalSkillBtn = null;
         for each(i in this.skillBtnArray)
         {
            i.destroy();
            i = null;
         }
         this.skillBtnArray = [];
      }
      
      public function hide() : void
      {
         this._mainUI.visible = false;
      }
      
      private function onShowComplete(o:DisplayObject) : void
      {
         this._showMc = o as MovieClip;
         if(Boolean(this._showMc))
         {
            DisplayUtil.stopAllMovieClip(this._showMc);
            this._showMc.scaleX = 2;
            this._showMc.scaleY = 2;
            this._showMc.x = 70;
            this._showMc.y = 110;
            this._mainUI.addChild(this._showMc);
         }
      }
      
      private function onEatSplItem(evt:SocketEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(evt:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,arguments.callee);
            PetManager.upDate();
         });
         SocketConnection.send(CommandID.GET_PET_INFO,this._petInfo.catchTime);
      }
   }
}

