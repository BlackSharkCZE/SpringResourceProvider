package sk.anext.oauth;

import org.springframework.security.oauth2.provider.token.RemoteTokenServices;

/**
 * <strong>Created with IntelliJ IDEA</strong><br/>
 * User: Jiri Pejsa<br/>
 * Date: 19.5.15<br/>
 * Time: 14:49<br/>
 * <p>To change this template use File | Settings | File Templates.</p>
 */
public class CustomRemoteTokenServices extends RemoteTokenServices {

	public CustomRemoteTokenServices() {
		setAccessTokenConverter(new CustomDefaultAccessTokenConverter());
	}
}
