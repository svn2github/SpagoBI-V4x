package it.eng.spagobi.commons.metadata;

// Generated 2-dic-2013 14.44.44 by Hibernate Tools 3.4.0.CR1

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * SbiAuthorizations generated by hbm2java
 */
public class SbiAuthorizations extends SbiHibernateModel{

	private int id;
	private String name;
	private Date creationDate;
	private Date lastChangeDate;
	private String userIn;
	private String userUp;
	private String userDe;
	private Date timeIn;
	private Date timeUp;
	private Date timeDe;
	private String sbiVersionIn;
	private String sbiVersionUp;
	private String sbiVersionDe;
	private String metaVersion;
	private String organization;
	private Set sbiAuthorizationsRoleses = new HashSet(0);

	public SbiAuthorizations() {
	}

	public SbiAuthorizations(int id, Date creationDate, Date lastChangeDate,
			String userIn, Date timeIn) {
		this.id = id;
		this.creationDate = creationDate;
		this.lastChangeDate = lastChangeDate;
		this.userIn = userIn;
		this.timeIn = timeIn;
	}

	public SbiAuthorizations(int id, String name, Date creationDate,
			Date lastChangeDate, String userIn, String userUp, String userDe,
			Date timeIn, Date timeUp, Date timeDe, String sbiVersionIn,
			String sbiVersionUp, String sbiVersionDe, String metaVersion,
			String organization, Set sbiAuthorizationsRoleses) {
		this.id = id;
		this.name = name;
		this.creationDate = creationDate;
		this.lastChangeDate = lastChangeDate;
		this.userIn = userIn;
		this.userUp = userUp;
		this.userDe = userDe;
		this.timeIn = timeIn;
		this.timeUp = timeUp;
		this.timeDe = timeDe;
		this.sbiVersionIn = sbiVersionIn;
		this.sbiVersionUp = sbiVersionUp;
		this.sbiVersionDe = sbiVersionDe;
		this.metaVersion = metaVersion;
		this.organization = organization;
		this.sbiAuthorizationsRoleses = sbiAuthorizationsRoleses;
	}

	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getCreationDate() {
		return this.creationDate;
	}

	public void setCreationDate(Date creationDate) {
		this.creationDate = creationDate;
	}

	public Date getLastChangeDate() {
		return this.lastChangeDate;
	}

	public void setLastChangeDate(Date lastChangeDate) {
		this.lastChangeDate = lastChangeDate;
	}

	public String getUserIn() {
		return this.userIn;
	}

	public void setUserIn(String userIn) {
		this.userIn = userIn;
	}

	public String getUserUp() {
		return this.userUp;
	}

	public void setUserUp(String userUp) {
		this.userUp = userUp;
	}

	public String getUserDe() {
		return this.userDe;
	}

	public void setUserDe(String userDe) {
		this.userDe = userDe;
	}

	public Date getTimeIn() {
		return this.timeIn;
	}

	public void setTimeIn(Date timeIn) {
		this.timeIn = timeIn;
	}

	public Date getTimeUp() {
		return this.timeUp;
	}

	public void setTimeUp(Date timeUp) {
		this.timeUp = timeUp;
	}

	public Date getTimeDe() {
		return this.timeDe;
	}

	public void setTimeDe(Date timeDe) {
		this.timeDe = timeDe;
	}

	public String getSbiVersionIn() {
		return this.sbiVersionIn;
	}

	public void setSbiVersionIn(String sbiVersionIn) {
		this.sbiVersionIn = sbiVersionIn;
	}

	public String getSbiVersionUp() {
		return this.sbiVersionUp;
	}

	public void setSbiVersionUp(String sbiVersionUp) {
		this.sbiVersionUp = sbiVersionUp;
	}

	public String getSbiVersionDe() {
		return this.sbiVersionDe;
	}

	public void setSbiVersionDe(String sbiVersionDe) {
		this.sbiVersionDe = sbiVersionDe;
	}

	public String getMetaVersion() {
		return this.metaVersion;
	}

	public void setMetaVersion(String metaVersion) {
		this.metaVersion = metaVersion;
	}

	public String getOrganization() {
		return this.organization;
	}

	public void setOrganization(String organization) {
		this.organization = organization;
	}

	public Set getSbiAuthorizationsRoleses() {
		return this.sbiAuthorizationsRoleses;
	}

	public void setSbiAuthorizationsRoleses(Set sbiAuthorizationsRoleses) {
		this.sbiAuthorizationsRoleses = sbiAuthorizationsRoleses;
	}

}
