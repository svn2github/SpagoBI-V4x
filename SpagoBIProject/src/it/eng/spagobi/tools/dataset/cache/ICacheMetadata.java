/**

SpagoBI - The Business Intelligence Free Platform

Copyright (C) 2005-2010 Engineering Ingegneria Informatica S.p.A.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

**/
package it.eng.spagobi.tools.dataset.cache;

import it.eng.spagobi.tools.dataset.cache.impl.sqldbcache.CacheItem;
import it.eng.spagobi.tools.dataset.common.datastore.IDataStore;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * @author  Marco Cortella (marco.cortella@eng.it)
 * 			Antonella Giachino (antonella.giachino@eng.it)
 *
 */
public interface ICacheMetadata {
	/**
	 * @return available cache memory in bytes
	 */
	BigDecimal getAvailableMemory();
	
	/**
	 * @return the percentage of the available cache memory on the total memory
	 */
	Integer getAvailableMemoryAsPercentage();
	
	/**
	 * @return the required memory in bytes to store the input resultSet in cache
	 */
	BigDecimal getRequiredMemory(IDataStore resultset);
	
	/**
	 * @return true if the cache space can contains the resultset
	 */
	boolean hasEnoughMemoryForResultSet(IDataStore resultset);
	
	
	/**
	 * @return true if the configuration about the clean action are correctly defined
	 */
	boolean isActiveCleanAction();
	
	/**
	 * @return the percentage of the memory to delete while cleaning cache
	 */
	Integer getAvailableMemoryBaseline();
	
	
	
	/**
	 * @return the cache registry map
	 */
	public LinkedHashMap<String, CacheItem> getCacheRegistry();
	
	/**
	 * set the cache registry map
	 */
	public void setCacheRegistry(LinkedHashMap<String, CacheItem> cacheRegistry);
	
	/**
	 * add a cacheItem 
	 */
	public void addCacheItem(String resultsetSignature, String tableName, IDataStore resultset);
	
	/**
	 * remove the cacheItem
	 */
	public void removeCacheItem(String signature);
	
	/**
	 * remove all the cacheItems
	 */
	public void removeAllCacheItems();
	
	/**
	 * @deprecated
	 * @return the cache item getted by table name
	 */
	public CacheItem getCacheItem(String signature);
	
	/**
	 * @return the  cache item getted by resultset signature
	 */
	public CacheItem getCacheItemByResultsetSignature(String resultSetSignature);
	
	/**
	 *@return true if the signature (tablename) already esists
	 */
	public boolean containsCacheItem(String signature);
	
	/**
	 *@deprecated
	 *@return true if the resultsetSignature already esists
	 */
	public boolean containsCacheItemByResultsetSignature(String resultSetSignature);
	
	/**
	 * @return the number of the objects cached
	 */
	public Integer getNumberOfObjects();
}
