<template>
  <v-card flat>
    <v-card-text>
      <h6 class="text-body-1 font-weight-bold">Status</h6>
    </v-card-text>

    <v-divider />

    <v-card-text>
      <KVText title="Approvals" :value="String(transaction.approvers.length)" />
      <KVText
        title="Rejections"
        :value="String(transaction.rejecters.length)"
      />

      <div class="d-flex mt-5" v-if="transaction.status == 1">
        <v-btn flat class="me-1" color="success" @click="$emit('approve')">
          Approve
        </v-btn>
        <v-btn flat class="ms-1" color="error" @click="$emit('reject')">
          Reject
        </v-btn>
      </div>
      <v-btn
        v-else-if="transaction.status == 2"
        flat
        block
        class="mt-5"
        color="primary"
        @click="$emit('execute')"
      >
        Execute
      </v-btn>

      <v-chip
        v-else-if="transaction.status == 3 || transaction.status == 4"
        flat
        label
        class="mt-5"
        variant="outlined"
        :color="transaction.status == 3 ? 'error' : 'success'"
      >
        <span class="text-center">
          {{ transaction.statusValue }}
        </span>
      </v-chip>
    </v-card-text>
  </v-card>
</template>

<script lang="ts" setup>
import { SafeTransaction } from "@/lib/entity";
import KVText from "@/components/text/KVText.vue";

defineProps<{ transaction: SafeTransaction }>();
defineEmits(["approve", "reject", "execute"]);
</script>
