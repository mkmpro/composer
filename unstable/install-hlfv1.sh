(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �7(Y �]Ys�Jγ~5/����o�Jմ6 ����)�v6!!~��/ql[7��/������|�tN7n�O��/�i� h�<^Q�D^���QCp��/�c8��F~Nwc����V��N��4{��k��P����~�MC{9=��i��>dF\.�&�J�e�5�ߖ��2.�?�Qɿ�Y���4��%	���P�wo{�{�l�\�Z�9�%���}��S���p��I�F+���k��O'^���r�I�8
�"�;y?��{4%i�K��I�y�;��q��Y�����������E0��pʦ\�F�B�i�uH��=�E(�GH�G}�"̵�"]E|¿�>k�U�9ʐ�I�)�E����c�����R� �����Nl�jM�>��t��Xk�֩R�.4Q�e$�e���$X`�{+X�R\�ʦ�m�0R�?����_5�
�B ��@���c%�&�'pG���&�OQ4�!
�\gu���=���p:�JH�w��L�	k[�ˋY�E�[�~dK��B]��:uVT�����=п)~I�m/�.]?]�<0����0�Z�+%�������ď<���8����te�K��ϋ�!K2_��[�/�|��y�vC��eMYJ|2�{[f���-�e�6���|��i� f\�hY�%����98��R<��甶�I�=o݈L,C*�v��v�:���,���5$g�H�9QW s��D�݆�p��~|w�z\��P��-ƣVύܝ�#H0D\�\9^���H0�Lޫ����Ď��L�4��x :t�sh�su�4���6�P�I308׹�`uS��F���c�{q ~�-]̅�4.��O����xk��X��?�&��B�7�D��bD(m����|7�Ȕ�	Ӱ��X�1je�>�����f9+�d�r�v���,7Gq�;S��kQ�с�@��'�"�xy2��4��������5���'�K
P80y�(r�r�,��t�1)m�&Fv��Ê	��R=0�6H�\�h�D�i��.C!J !P�/k<y:9�����	t	#.b�fu0���n����ڹr�Iڒ�hj�x1��C&K f�ȱh�sfы��(�e��f�߭�����6�@������|���?�^��)�c�OP�x���Y��Nt��:PC��f{��W�d�%��'�s>��v<�3�H'B�~Ĩ�*�#F};��rd��A��`� �EY��`����2E�w�����0EWrH<�0��'�5�%��;�b��V.�S]S�Q���lM�HM\L���C�n�߻e�.�i���ռ�"ľ@h�}�].?���gᲭN�ȅ�D�=�5an[8�ȑ�[���9k@@H\^T��!��
 y;?�d��Z.� ����>kr���r�Mwp�x/��-��))�D"�a�t�zr�a�:D�bH}0�m�`B2���q���D���ϛX��X��Q���o�m������}?��Z2��h�Y�!���:��x��_���������d��Q
>D�?���'�G(���T��W�������sN���_D�x��e������?��W
���*������):�I#������8E��_�!h��Ew�e
���E� �h��H�����P��_��~��Ch�����vO��M
Zy8�XOP�Yǳ�>WD�qpa��Q��Ë�?k�؂m�
f�dܐ����[&_z˖2�'�!rXm|�1�>��:ݎ,h��ܘ��%���_�[P�	v��lO�*���%�����*��|��?<����������j��Z�{��������K���Q����T�_)x[�����{3��#�C��)���h��t��>����c����n�]���� ���&s�P�\��#�.�CL2����ܚ�=���a�|�P��I��N���lXo&�w�A�1hJ�x\(�R��;Y�c옞�'Zט#m�G��lp�H:����9;'�8���c� N��9aH΁ ҳo��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2iBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K������2�!�������KA�W���������k�����->P��D��������1�x[���������\����P�/��E	R����K��cl����u(�p�v};@�Y�sG�%Pa�a� !}�Y���*���C�<��sQ�%���?�	�"�Z�T��csbkL�6��s�U�����Г��b�J }'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߻�X�����?���-Կ��K�������c�����.����eF�r��U�)x��޾|�8\.ǨJ�e�#���vЋ�_�������wX��p���O�Z�)���,��E��bD�b�cۤ��K�.F!�K�,f{X�������L8��2��VE���_���#�������?]D��� �D4L^L�ݠ�nci�x�s�X鮑&����V�p�e���+�au]��S��0"7�3�`��(�|�G�|F�T��Nc�[����&���k��3[��ލ���������#�*�+������S��B���+����/��P&ʐ�+�_a��E���+�����_����΁X�qе�x�%,�!?;�y<���%�������a�'Ui��%U��n�/���CwA�����h�� ���=�Z�a��=
'���N1��+ݥ����A?�$��}�؄q��1r-��f��Ex�p�LNp�ɬ'��x��bs5�9jo�EsI�٠��`�uF9��z��2<�Q&�=b��Mb����k�Mba΅�x|�s�[SW�m��Dk�
?o@���P�r<����T���xl�A�Z�n�yP�:#���6\����`t�A�	NSΦ�4o���7�ڊlt��H�,�e�S����Ӷ7���{@��p��f�	zR.�do��l��-�U].��x�4��������������q���K�o��Sx���M���Am��(C������(Y��^
޶����c��_��n�$��T�wx��#�����2?y�(?��G�t���@�O��@�	[F-PS �]��'a�����yЃ!c;9�ݔ����E%qG4�f#�e�\k�-[�)Ѷw�o�T�]K�t*�1I�4�.�S��]K$�_����4^;zz ��σ8��Х��cw �5�͑��hmւg�.��}{��Y#Yͥ.���d.���j�l��;�j��7|��N�aFHt��*�>=l<����O����� .������J�o�����?��?%�3��Z�����g���������������j��Z����)0��X����K���ܻ���1
����RP��������[��P�������J���Ox�M���(�8�.C�F��O�L�8��C�O��#��b��`xu
�o�2�������_H�Z�)��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��{����O���8������s�GO����B�H��_�`�Ya��������O�S�ϾB��k#�K�6����Z��?]�^X�c`;�Խr��;����+��F��E2�O���i/#�>ߤV��I��e��7ͮ"~�����W�~���I�����������?�:�7����Z6�]����ޣv�vU�\W+��¯���'�}_�8�h��/����W�rj�_O�&�_�+�4�x���ct_r��׷~���^����Oo�vT�
׾��T4��ng���w��L��fͭ�.����4DU�A�#�Q�����7�������k_�+���
ߎ�}��$w~0������<��0���*�΢��/w�˃����·��śW[���Q��9l/����o���:b�]�E��=��e҂H�?m��w������{=�~�;}����n��A��~+�^{��\c�-���rQk�a�������|�o�i������^O�,u�p��l���d�@�I�ު=,|b	�!�##p6�U�n�>j������gd���0��<��^��6���7|�*��q$�C4dE��o��y�VGƷu���J�3B�+�Ʒ�r��
��$����N�t��Ϟ�u�P�O��ż-T���]m��d���rx.\%�� �1����뺗�u�麭{ߔ\{���֭=�މ	jBL0�%h�$h�����~R�4��H���#
1Q?�m��lg�9;����M�����ҧ��������<��7{I/6�Θ#���ܔ�A	���]!�,�L��H
�FÃ�xA�H2���.%ӑx׭mY;&�:z��"���2�N�q���ʹ�fet,����D�y�'����6!�v1a\ȇm�wTeI�{:884��6�����D�8�����[f&M7�� �Z-�m����L�,��V4]7um����8cg֫���;�$(�>��Lv�C�-d�4E��q	�
_e;R���,�7�h}0�׌3�U�=4��H�̪��5Π˰Ѳ��f�����!�PZ����YG�W�VE��{���Y^�M��h�|��t��o�t�M�)r8]�ɆSN���98�������trb��;�G�_'W�A���EEb�*wZ�E�}��\���c��j���e�u���_�2�&�t*i��H�s�ou�C֑�����sFO�T�x֜��H�2�4ҹ�+�5�o��2�+Q�5N�)F�`t������Շ��|m]p\r����T��2��c����M�z�b����\4([�(E������@]�9�Z�+7��9��ˑ~�S{����|U2�-�
�ÍF1���|vϹ����$�B��ɏ9)�:b!Cf<�Kp���:��2b�f�mN�4��޴��tx��Kǧ�}�a�+#��U{I6ta-*���B��.dy��>G����89���U�t?�}��C�y�(�sy�`�؟O>��{��w������Qc����?��������O��8x�Nl�Z{�ߏ��j絖J\x`���.��@�`,��E�U�uc�^�G�׳��V]����*���#��C9=�����Cgoo�vǙ_���ح��wO<����ڥG��9�
<C��J7����9�5�@8�C'��� ��š����9p�q��9���'��\���H�A���>=�Ծ�_���d}����Y�<0"�Ὠ�%�,ף��m��$^�0{����� ��a���6���e�z�����`#G$7C�6�%�n�3�,�Q��!�n�_��[��!��L��P;e��k`�4��Wɝ.��i2_�Q,S�׃���l���A�#pF��Ɇn�R�$�l����0GaJ����&j|?Mg��hG�X�)�A�/�����,
�L:;�+��f�(�ȄT*{j�l�G	�F)/�0,��-!&$=���,$�������C|��Ԕ'��z)D�!X.�G>e3am&�̈́]�	=} �n����E��Ԧ�:�Z�z�C�kvzK�.�����JȺUq0���h��d#n<(owœ�LR�n��2W��p_�#^���2A4�'Q��o5z��	%�L��6��|B"��CV�v�4�.�`�A"ԎdX��������+�CV�ل��l����A�
Amk�r<B�S�H��j���q�d%�U:�>�v�j�����D�@�)�apw=��cLd�m4�}e	��,ـuFY�ܙ�\w@
d���p*%����N488�������g�V4�v��6����P>�S-�IqJt���/B��ʠ
����g$:�%*B��*�h��1y<ӒRsʲGxFv��DU��h�7$	����V��9�`W'���p�I�8b*�`X-�;Q����J%#5?�k2�|�PM�}����
�ﭲ�)K����W��
�Ec=��|���Q�t�Y $(q����;)t�Z3�]���_I�|/5,��q%Z��vr�İR�������HLj�	 '܇S����I�A��j�,��7¤\�L�c�9e�#<#�TY��&��0��Ū�>-�T�{�,�+�k�%��7�p�9D���I��ɾ�T�6!�}�B�3#٤Ȗ#� ��$�����8m����l�m5�m�n�4'
�)��6�j�G�skWB�tJ�{b튍3�uӯ�V&A �.{�T�u��t��+��J�l�PUm���mN4B�r��]�v{]M���!T�����7�n�n7��+m\�F'7�7��B���j����AkSU]O�g���Ѳ��֡S�&K�%�ך��Ԇ<t3tz�?��s�هvX��:�,tf�*L~���d.��0�J���r��z]�Z�qL�gu�%3>1-3y��ʁ�;N㊢�Ũ�g�C/CF`Ō�C�C�.��DY5>�i�: �ڌ��?�#�_�[�ȍ������[����w˳_
엂�_
?p�-<���[$��3�.V�|+���le��}�AK	����Xt0�梃Ѡd�AO���`iς�Gu��I���iL7k� �=�w�{�1��7=4E��!�)5�Eҫz؈�EX)�E�@8R����hőh��~����WH�n!8�Ŕ�h^wn�u:�q%_�8Vh�c�rhd�:�����ᑠ�6���ӘI��ݣ&�C�±DM�05:D��g���ꪷC�fj9�i�:F��|>��O(�*q�2��T�q6�AZ��se�u�7�76���6D;�O�bB�%�[$��yյn��i
�$u�-��r�ǥ�V�c<��q8m㰍�6��X׮�t7t��T�2�\�6���c2�c�3���<�{�;t�[�2\��2����}���^���1�������ܗ�ò#i�Hڪ�Hf*8�6J�J)7p�K2�:�e؜�|�����b�KQ���`��>��D�Q�"�V�QPd�YS�՟c�w��Fm*	LL);q1D�A0�L��Ni��r&��tP8��Ѳ��/+]n�4��������/
�K)	�bB8Z��썅��Cvc!D����A���0!RcKM���pp�(O���nAy��._ڙ�+�Ŷ;"��|��R<���Byq�Y&�P�l�3� BW��B{���Ė��9@7Y����R.��t���V/�¾K;��a��a���q��q�F�Vr�܇v�fr��Z)$�B�m�"��ۅ�6e5��2m�õ;�-\���n�_G4�JE�5���^�\?���σ�q��$��-�M����Lw{}�\�W�Mҟ�I�t���^���G~��V�;>��/륧��]_z�/���q�Zc?�������f�ٴp��1�q ���]�Ç���˒�s����Ƀt��7N���_�n<�@���y�__|���?=�^<߉?�u�J��~erEO�ym4��V�6��o�?�'?����n���󯁗����Г��x���HA��v���ޜ�v�jS;mj�M��i6M��v�_q��_q퀴����6�Ӧv�>��������[^F>�C�*W����Y�=�rAl�נ�B'��zl��c&�N�����/�C�MQ^�l�����<�S��)����a�{�38G����Af���צ��,��93v�՞3cO���sfl㰍�2̙9�|�#L��3s.w���Ui��.y�ɜ��/�:h\1�g';��Nvzߦ����  