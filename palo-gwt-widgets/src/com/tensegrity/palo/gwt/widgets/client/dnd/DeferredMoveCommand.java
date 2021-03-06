/*
*
* @file DeferredMoveCommand.java
*
* Copyright (C) 2006-2009 Tensegrity Software GmbH
*
* This program is free software; you can redistribute it and/or modify it
* under the terms of the GNU General Public License (Version 2) as published
* by the Free Software Foundation at http://www.gnu.org/copyleft/gpl.html.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
* more details.
*
* You should have received a copy of the GNU General Public License along with
* this program; if not, write to the Free Software Foundation, Inc., 59 Temple
* Place, Suite 330, Boston, MA 02111-1307 USA
*
* If you are developing and distributing open source applications under the
* GPL License, then you are free to use JPalo Modules under the GPL License.  For OEMs,
* ISVs, and VARs who distribute JPalo Modules with their products, and do not license
* and distribute their source code under the GPL, Tensegrity provides a flexible
* OEM Commercial License.
*
* @author Philipp Bouillon <Philipp.Bouillon@tensegrity-software.com>
*
* @version $Id: DeferredMoveCommand.java,v 1.2 2009/12/17 16:14:15 PhilippBouillon Exp $
*
*/

/*
 * Copyright 2008 Fred Sauer
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
package com.tensegrity.palo.gwt.widgets.client.dnd;

import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.Command;
import com.google.gwt.user.client.DeferredCommand;

/**
 * Used by {@link MouseDragHandler} to improve drag performance on slower
 * platforms.
 */
class DeferredMoveCommand implements Command {

  private static final int PERFORMANCE_THRESHOLD_MILLIS = 80;

  private long mostRecentTotalTime;

  private MouseDragHandler mouseDragHandler;

  private long scheduledTimeMillis;

  private int x;

  private int y;

  DeferredMoveCommand(MouseDragHandler mouseDragHandler) {
    this.mouseDragHandler = mouseDragHandler;
  }

  public void execute() {
    if (scheduledTimeMillis == 0) {
      return;
    }
    mouseDragHandler.actualMove(x, y);
    mostRecentTotalTime = System.currentTimeMillis() - scheduledTimeMillis;
    scheduledTimeMillis = 0;
  }

  /**
   * Either execute {@link MouseDragHandler#actualMove(int, int)} immediately or
   * schedule via {@link DeferredCommand#add(Command)}. This is done as a
   * work-around for slow otherwise slow performance on Firefox/Linux
   * (discovered on Ubuntu). The decision is made as follows:
   * <ul>
   * <li>In Hosted Mode, always execute immediately.</li>
   * <li>In Web Mode execute immediately, unless most recent processing time
   * exceeded {@link #PERFORMANCE_THRESHOLD_MILLIS} ({@value #PERFORMANCE_THRESHOLD_MILLIS}
   * milliseconds).</li>
   * </ul>
   * 
   * @param x the left mouse move position
   * @param y the top mouse move position
   */
  void scheduleOrExecute(int x, int y) {
    this.x = x;
    this.y = y;
    if (scheduledTimeMillis == 0) {
      scheduledTimeMillis = System.currentTimeMillis();
    }
    // Select method to perform move:
    // 
    // Hosted Mode:
    // execute immediately
    // Web Mode
    if (GWT.isScript() && mostRecentTotalTime > PERFORMANCE_THRESHOLD_MILLIS) {
      DeferredCommand.addCommand(this);
    } else {
      execute();
    }
  }
}
