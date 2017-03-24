<?php
namespace Keycloak\API;

/**
 * Roles class
 *
 * This class provide an easy to use interface for
 * the Keycloak Roles REST API.
 */
class Roles {

    private $base_endpoint_url;
    private $admin_username;
    private $admin_password;
    private $verify_peer;

    public function __construct($base_endpoint_url, $admin_username, $admin_password, $verify_peer) {
        $this->base_endpoint_url = $base_endpoint_url;
        $this->admin_username = $admin_username;
        $this->admin_password = $admin_password;
        $this->verify_peer = $verify_peer;
    }

    /**
     * Get representations of all of a realm's roles
     * GET /admin/realms/{realm}/roles
     * Returns Array of RoleRepresentation
     */
    public function getRoles($realm){

        // get access token for admin API
        $access_token = $this->getAPIAccessToken();
        $r = curl_init($this->base_endpoint_url . '/admin/realms/' . rawurlencode($realm) . '/roles');
        curl_setopt($r, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($r, CURLOPT_ENCODING, 1);
        curl_setopt($r, CURLOPT_SSL_VERIFYPEER, $this->verify_peer);
        curl_setopt($r, CURLOPT_HTTPHEADER, array(
            "Authorization: Bearer " . $access_token
        ));

        $response = curl_exec($r);
        if ($response == false) {
            die("curl_exec() failed. Error: " . curl_error($r));
        }
        $result = json_decode($response);
        // Log::debug("getRealmRoleMappingsForUser result", array($result));
        return $result;
    }

    // TODO: factor this out into base class?
    private function getAPIAccessToken() {

        // http://www.keycloak.org/docs/2.5/server_development/topics/admin-rest-api.html
        // curl -d client_id=admin-cli -d username=username \
        //   -d "password=password" -d grant_type=password https://149.165.156.62:8443/auth/realms/master/protocol/openid-connect/token

        $r = curl_init($this->base_endpoint_url . '/realms/master/protocol/openid-connect/token');
        curl_setopt($r, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($r, CURLOPT_ENCODING, 1);
        curl_setopt($r, CURLOPT_SSL_VERIFYPEER, $this->verify_peer);

        // Assemble POST parameters for the request.
        $post_fields = "client_id=admin-cli&username=" . urlencode($this->admin_username) . "&password=" . urlencode($this->admin_password) . "&grant_type=password";

        // Obtain and return the access token from the response.
        curl_setopt($r, CURLOPT_POST, true);
        curl_setopt($r, CURLOPT_POSTFIELDS, $post_fields);

        $response = curl_exec($r);
        if ($response == false) {
            die("curl_exec() failed. Error: " . curl_error($r));
        }

        $result = json_decode($response);
        // Log::debug("API Access Token result", array($result));
        return $result->access_token;
    }
}