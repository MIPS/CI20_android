/*
 * Copyright (C) 2014 water.zhou2011@gmail.com.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.dog.ethernet;

import android.os.Bundle;
import android.app.Activity;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import android.widget.Button;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.DialogInterface;
import com.dog.ethernet.EthernetDevInfo;
import android.view.View.OnClickListener;
import android.text.method.ScrollingMovementMethod;
import android.view.Window;
import android.view.WindowManager;

public class MainActivity extends Activity {
    private static EthernetEnabler mEthEnabler;
    private EthernetConfigDialog mEthConfigDialog;
    private Button mBtnConfig;
    private Button mBtnCheck;
    private EthernetDevInfo  mSaveConfig;
    private String TAG = "MainActivity";
    private static String Mode_dhcp = "dhcp";
    private boolean shareprefences_flag = false;
    private boolean first_run = true;
    public static final String FIRST_RUN = "ethernet";
    private Button mBtnAdvanced;
    private EthernetAdvDialog mEthAdvancedDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.ethernet_configure);
        SharedPreferences sp = getSharedPreferences("ethernet",
                Context.MODE_WORLD_WRITEABLE);

        createNewEthernetEnabler(this);
        mEthConfigDialog = new EthernetConfigDialog(this, mEthEnabler);
        mEthEnabler.setConfigDialog(mEthConfigDialog);
        mEthAdvancedDialog = new EthernetAdvDialog(this, mEthEnabler);
        mEthEnabler.setmEthAdvancedDialog(mEthAdvancedDialog);
        addListenerOnBtnConfig();
        addListenerOnBtnCheck();
        addListenerOnBtnAdvanced();
    }

    public static void createNewEthernetEnabler(Context context){
        mEthEnabler = new EthernetEnabler(context);
        mEthEnabler.getManager().initProxy();
    }

    public void addListenerOnBtnConfig() {
        mBtnConfig = (Button) findViewById(R.id.btnConfig);

        mBtnConfig.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                mEthConfigDialog.show();
            }
        });
    }

    public void addListenerOnBtnCheck() {
        mBtnConfig = (Button) findViewById(R.id.btnCheck);

        mBtnConfig.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                TextView text = (TextView) findViewById(R.id.tvConfig);
                text.setMovementMethod(ScrollingMovementMethod.getInstance());
                mSaveConfig = mEthEnabler.getManager().getSavedConfig();
                if (mSaveConfig != null) {
                    String config_detail = getString(R.string.ip_mode) + ": ";
                    if(mEthEnabler.getManager().getSharedPreMode() != null) {
                        config_detail += mEthEnabler.getManager().getSharedPreMode();
                    }
                    config_detail += "\n" + getString(R.string.eth_ipaddr) + ": ";
                    if(mEthEnabler.getManager().getSharedPreIpAddress() != null) {
                        config_detail +=  mEthEnabler.getManager().getSharedPreIpAddress();
                    }
                    config_detail += "\n" + getString(R.string.eth_dns) + ": ";
                    if(mEthEnabler.getManager().getSharedPreDnsAddress() != null) {
                        config_detail += mEthEnabler.getManager().getSharedPreDnsAddress();
                    }
                    config_detail += "\n" + getString(R.string.eth_proxy_address) + ": ";
                    if(mEthEnabler.getManager().getSharedPreProxyAddress() != null) {
                        config_detail += mEthEnabler.getManager().getSharedPreProxyAddress();
                    }
                    config_detail += "\n" + getString(R.string.proxy_port) + ": ";
                    if(mEthEnabler.getManager().getSharedPreProxyPort() != null) {
                        config_detail += mEthEnabler.getManager().getSharedPreProxyPort();
                    }
                    text.setText(config_detail);
                }
            }
        });
    }

    public void addListenerOnBtnAdvanced() {
        mBtnAdvanced = (Button) findViewById(R.id.btnAdvanced);

        mBtnAdvanced.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                mSaveConfig = mEthEnabler.getManager().getSavedConfig();
                if (mSaveConfig != null) {
                    mEthAdvancedDialog.show();
                }
            }
        });
    }
}
