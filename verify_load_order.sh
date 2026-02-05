#!/bin/bash
# Load Order Verification Script
# Tests that all critical ordering requirements are met

set -e

echo "==================================================================="
echo "Load Order Verification Script"
echo "==================================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper function to print test result
test_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $2"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "${RED}✗ FAIL${NC}: $2"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
}

echo "Test 1: Syntax Check (luacheck)"
echo "-------------------------------------------------------------------"
if command -v luacheck &> /dev/null; then
    luacheck lua/plugins/lsp.lua lua/plugins/tools.lua lua/plugins/cmp.lua lua/core/lifecycle/init.lua --no-color > /tmp/luacheck.log 2>&1
    test_result $? "Lua syntax validation"
else
    echo -e "${YELLOW}⚠ SKIP${NC}: luacheck not installed"
fi
echo ""

echo "Test 2: Neovim Startup"
echo "-------------------------------------------------------------------"
nvim --headless "+lua print('OK')" +qa > /tmp/nvim-startup.log 2>&1
test_result $? "Neovim starts without errors"
echo ""

echo "Test 3: Load Order Logging"
echo "-------------------------------------------------------------------"
# Create a test file
echo "local test = {}" > /tmp/nvim_test.lua

# Start Neovim with debug mode and capture load order
nvim --headless --cmd "let g:debug_plugin_load=1" \
     -c "sleep 500m" \
     -c "lua require('core.lifecycle').print_load_summary()" \
     -c "qa!" \
     /tmp/nvim_test.lua > /tmp/load_order.log 2>&1

if grep -q "nvim-navic" /tmp/load_order.log && grep -q "nvim-lspconfig" /tmp/load_order.log; then
    # Extract positions
    NAVIC_POS=$(grep -n "nvim-navic" /tmp/load_order.log | head -1 | cut -d: -f1)
    LSPCONFIG_POS=$(grep -n "nvim-lspconfig" /tmp/load_order.log | head -1 | cut -d: -f1)

    if [ "$NAVIC_POS" -lt "$LSPCONFIG_POS" ]; then
        test_result 0 "navic loads before lspconfig (pos $NAVIC_POS < $LSPCONFIG_POS)"
    else
        test_result 1 "navic loads before lspconfig (pos $NAVIC_POS >= $LSPCONFIG_POS)"
    fi
else
    echo -e "${YELLOW}⚠ SKIP${NC}: Could not verify navic/lspconfig order (plugins may not have loaded)"
fi
echo ""

echo "Test 4: Debug Mode Assertions"
echo "-------------------------------------------------------------------"
nvim --headless --cmd "let g:debug_lifecycle=1" \
     -c "sleep 500m" \
     -c "messages" \
     -c "qa!" > /tmp/assertions.log 2>&1

if grep -q "assertion passed" /tmp/assertions.log || grep -q "all load order assertions passed" /tmp/assertions.log; then
    test_result 0 "Load order assertions run in debug mode"
else
    echo -e "${YELLOW}⚠ SKIP${NC}: Assertions may not have run (check /tmp/assertions.log)"
fi

if grep -q "ASSERTION FAILED" /tmp/assertions.log; then
    test_result 1 "No failed assertions"
    echo "Failed assertions found in /tmp/assertions.log:"
    grep "ASSERTION FAILED" /tmp/assertions.log
else
    test_result 0 "No failed assertions"
fi
echo ""

echo "Test 5: Plugin Specs Valid"
echo "-------------------------------------------------------------------"
# Check that mason-lspconfig has explicit spec
if grep -q '"williamboman/mason-lspconfig.nvim"' lua/plugins/lsp.lua && grep -A 5 '"williamboman/mason-lspconfig.nvim"' lua/plugins/lsp.lua | grep -q 'opts = {'; then
    test_result 0 "mason-lspconfig has explicit plugin spec"
else
    test_result 1 "mason-lspconfig has explicit plugin spec"
fi

# Check that navic has detailed comment
if grep -q "CRITICAL ORDERING" lua/plugins/lsp.lua; then
    test_result 0 "navic dependency has detailed documentation"
else
    test_result 1 "navic dependency has detailed documentation"
fi

# Check that blink.cmp has known limitation comment
if grep -q "KNOWN LIMITATION" lua/plugins/cmp.lua; then
    test_result 0 "blink.cmp has limitation documentation"
else
    test_result 1 "blink.cmp has limitation documentation"
fi

# Check that conform has format priority comment
if grep -q "FORMAT PRIORITY" lua/plugins/tools.lua; then
    test_result 0 "conform has format priority documentation"
else
    test_result 1 "conform has format priority documentation"
fi

# Check that lifecycle has verify_load_order function
if grep -q "verify_load_order" lua/core/lifecycle/init.lua; then
    test_result 0 "lifecycle has load order assertions"
else
    test_result 1 "lifecycle has load order assertions"
fi
echo ""

echo "==================================================================="
echo "Verification Summary"
echo "==================================================================="
echo -e "${GREEN}Passed:${NC} $TESTS_PASSED"
echo -e "${RED}Failed:${NC} $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All verifications passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Test manually: nvim --cmd \"let g:debug_plugin_load=1\" test.lua"
    echo "  2. Check :LoadOrder inside Neovim"
    echo "  3. Check :messages for assertion results"
    exit 0
else
    echo -e "${RED}✗ Some verifications failed.${NC}"
    echo ""
    echo "Check logs:"
    echo "  - /tmp/luacheck.log"
    echo "  - /tmp/nvim-startup.log"
    echo "  - /tmp/load_order.log"
    echo "  - /tmp/assertions.log"
    exit 1
fi
